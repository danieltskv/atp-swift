//
//  MyItinerariesVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 27.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import CoreLocation.CLLocation
import SDWebImage
import DZNEmptyDataSet

class MyItinerariesVC: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView() // A little trick for removing the cell separators

        
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: Class Methods
    

    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard DataManager.sharedInstance.currentUser != nil else {
            return 0
        }
        
        guard let count = DataManager.sharedInstance.currentUser?.itineraries?.count else {
            return 0
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("itineraryCell", forIndexPath: indexPath)

        guard let itinerary = DataManager.sharedInstance.currentUser?.itineraries?[indexPath.row] else {
            return cell
        }
        
        guard let destination = itinerary.destination else {
            return cell
        }
        
        if let titleLabel = self.view.viewWithTag(1) as? UILabel {
            titleLabel.text = String(format: "%@, %@", destination.city!, destination.country!)
        }
        
        if let subtitleLabel = self.view.viewWithTag(2) as? UILabel {
            subtitleLabel.text = String(format: "%d %@", itinerary.pois!.count, NSLocalizedString("Places", comment: ""))
        }
        
        if let imageView = self.view.viewWithTag(3) as? UIImageView {
            if destination.imageURL != nil {
                imageView.sd_setImageWithURL(destination.imageURL, placeholderImage: UIImage.init(named: "ic_insert_photo_48pt"))
            }
        }

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let itinerary = DataManager.sharedInstance.currentUser?.itineraries?[indexPath.row] else {
                return
            }
            
            guard let user = DataManager.sharedInstance.currentUser else {
                return
            }
            
            user.removeItinerary(itinerary)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            DataManager.sharedInstance.saveUser()
            
            tableView.reloadEmptyDataSet()
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toItinerary" {
            let vc = segue.destinationViewController as! ItineraryListVC
            //vc.hidesBottomBarWhenPushed = true
            
            guard let itinerary = DataManager.sharedInstance.currentUser?.itineraries?[tableView.indexPathForSelectedRow!.row] else {
                return
            }
            vc.itinerary = itinerary
            vc.canEdit = true
        }
    }
    
    // MARK: - DZNEmptyDataSetSource
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("No Itineraries", comment: "")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let str = NSLocalizedString("When you add itineraries, you'll see theme here. You can use the Explore tab to add them.", comment: "")
        let attrs = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleBody)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "ic_flight_takeoff_48pt")
    }

}
