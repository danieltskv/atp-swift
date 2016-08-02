//
//  ItineraryListVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 21.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import SVProgressHUD

class ItineraryListVC: UITableViewController {

    // MARK: - Properties

    var itinerary: Itinerary?
    var canEdit: Bool = false
    
    @IBOutlet weak var visibilityBarButtonItem: UIBarButtonItem!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        if canEdit {
            let editBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_mode_edit"),
                                                    style: .Plain,
                                                    target: self,
                                                    action: #selector(toggleEditingPressed))

            let spaceBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            spaceBarButtonItem.width = -30
            
            let mapBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_map"),
                                                                    style: .Plain,
                                                                    target: self,
                                                                    action: #selector(showItineraryMap))
            
            self.navigationItem.rightBarButtonItems = [mapBarButtonItem, spaceBarButtonItem, editBarButtonItem]
            
        } else {
            
            let addBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_add"),
                                                                    style: .Plain,
                                                                    target: self,
                                                                    action: #selector(addItineraryPressed))
            
            let spaceBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            spaceBarButtonItem.width = -30
            
            let mapBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_map"),
                                                                    style: .Plain,
                                                                    target: self,
                                                                    action: #selector(showItineraryMap))
            
            self.navigationItem.rightBarButtonItems = [mapBarButtonItem, spaceBarButtonItem, addBarButtonItem]
        }
        
        self.title = self.itinerary?.name ?? NSLocalizedString("Itinerary", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if canEdit && self.navigationController!.toolbarHidden {
            self.navigationController?.setToolbarHidden(false, animated: true)
            refreshItineraryView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    
        if canEdit && !self.navigationController!.toolbarHidden {
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    // MARK: - Convenience
    
    func refreshItineraryView() {
        let image = (itinerary?.visibility == .Private) ? UIImage(named: "ic_lock") : UIImage(named: "ic_lock_open")
        visibilityBarButtonItem.image = image
    }

    // MARK: - Actions

    func toggleEditingPressed() {
        self.setEditing(!self.editing, animated: true)
    }

    func addItineraryPressed() {
        guard let user = DataManager.sharedInstance.currentUser, let itinerary = itinerary else {
            let alert = UIAlertController(title: NSLocalizedString("Cannot Add Itinerary", comment: ""),
                                          message: NSLocalizedString("Please signup before adding itineraries.", comment: ""),
                                          preferredStyle: .Alert)
            
            let signup = UIAlertAction(title: NSLocalizedString("Signup", comment: ""), style: .Default) { [weak self] action in
                self?.performSegueWithIdentifier("toLogin", sender: self)
            }
            
            alert.addAction(signup)
            
            let cancel = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .Cancel, handler: nil)
            alert.addAction(cancel)
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Add Itinerary?", comment: ""),
                                      message: NSLocalizedString("This action will add this itinerary to your profile.", comment: ""),
                                      preferredStyle: .ActionSheet)
        
        let action = UIAlertAction(title: NSLocalizedString("Add", comment: ""), style: .Default) { action in
            user.addItinerary(itinerary)
            DataManager.sharedInstance.saveUser()
            SVProgressHUD.showSuccessWithStatus(NSLocalizedString("Itinerary Added", comment: ""))
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sharePressed(sender: UIBarButtonItem) {
        if let textToShare = itinerary?.name {
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addNotePressed(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Notes", comment: ""),
                                                message: NSLocalizedString("Add/Change itinerary notes", comment: ""),
                                                preferredStyle: .Alert)

        let addNoteAction = UIAlertAction(title: NSLocalizedString("Add Notes", comment: ""), style: .Default) { [weak self] (_) in
            let noteTextField = alertController.textFields![0] as UITextField
            self?.itinerary?.userNotes = noteTextField.text
            DataManager.sharedInstance.saveUser()
        }
        addNoteAction.enabled = false
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { [weak self] (textField) in
            textField.placeholder = NSLocalizedString("Notes", comment: "")
            textField.text = self?.itinerary?.userNotes
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addNoteAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(addNoteAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func toggleVisibilityPressed(sender: UIBarButtonItem) {
        guard let itinerary = itinerary else {
            return
        }
        
        if itinerary.visibility == .Private {
            itinerary.visibility = .Public
        } else {
            itinerary.visibility = .Private
        }
        
        refreshItineraryView()
    }
    
    @IBAction func deletePressed(sender: UIBarButtonItem) {
        
        guard let itinerary = itinerary else {
            return
        }
        
        guard let user = DataManager.sharedInstance.currentUser else {
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Delete Itinerary", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to delete this itinerary?", comment: ""),
                                      preferredStyle: .ActionSheet)
        
        let action = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .Destructive) { [weak self] action in
            user.removeItinerary(itinerary)
            DataManager.sharedInstance.saveUser()
            self?.navigationController?.popViewControllerAnimated(true)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard self.itinerary != nil else {
            return 0
        }
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itinerary?.pois?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("placeCell", forIndexPath: indexPath) as! PlaceTableViewCell

        // Configure the cell...
        let place = self.itinerary?.pois?[indexPath.row]
        cell.place = place
        
        cell.subtitleLabel.text = String(format:"1%d:00", indexPath.row)
        
        if indexPath.row == 0 {
            cell.line1View.hidden = true
            cell.line2View.hidden = false
        } else if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0)-1 {
            cell.line1View.hidden = false
            cell.line2View.hidden = true
        } else {
            cell.line1View.hidden = false
            cell.line2View.hidden = false
        }
        
        return cell
    }
    
    // MARK: - Editing
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.itinerary!.pois!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }   
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let item = self.itinerary!.pois![fromIndexPath.row]
        self.itinerary!.pois!.removeAtIndex(fromIndexPath.row)
        self.itinerary!.pois!.insert(item, atIndex: toIndexPath.row)
    }

    // MARK: - Navigation

    func showItineraryMap() {
        self.performSegueWithIdentifier("toMapView", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMapView" {
            let vc = segue.destinationViewController as! ItineraryMapVC
            vc.itinerary = itinerary
        } else if segue.identifier == "toPlaceDetails" {
            let vc = segue.destinationViewController as! PlaceVC
            vc.place = self.itinerary?.pois?[self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
