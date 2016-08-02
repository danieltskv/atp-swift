//
//  AccountTVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 31.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import MessageUI

class AccountTVC: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var firstCellTitleLabel: UILabel!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData() //if user logs in or out
        
        setupUser()
    }
    
    // MARK: - Actions
    
    func setupUser() {
        if let user = DataManager.sharedInstance.currentUser {
            firstCellTitleLabel.text = user.name
        } else {
            firstCellTitleLabel.text = NSLocalizedString("Sign up", comment: "")
        }
    }
    
    func logoutPressed() {
        let alert = UIAlertController(title: NSLocalizedString("Logout", comment: ""),
                                      message: NSLocalizedString("Are you sure you want to log out?", comment: ""),
                                      preferredStyle: .ActionSheet)
        
        let action = UIAlertAction(title: NSLocalizedString("Logout", comment: ""), style: .Destructive) { [weak self] action in
            DataManager.sharedInstance.removeUser()
            self?.tableView.reloadData()
            self?.setupUser()
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func sharePressed() {
        let activityViewController = UIActivityViewController(activityItems: ["Automatic Trip Planner"], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    func contactPressed() {
        //Check to see the device can send email.
        if ( MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Automatic Trip Planner")
            mailComposer.setToRecipients(["dtapps.contact@gmail.com"])
            self.presentViewController(mailComposer, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Cannot send email",
                                                    message: "Please add an account before sending emails.",
                                                    preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { (action) in
            
            }
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if DataManager.sharedInstance.currentUser == nil {
                return 1
            } else {
                return 2
            }
        } else {
            return 3
        }
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if DataManager.sharedInstance.currentUser == nil {
                    performSegueWithIdentifier("toLogin", sender: self)
                }
            } else if indexPath.row == 1 {
                if DataManager.sharedInstance.currentUser != nil {
                    logoutPressed()
                }
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                sharePressed()
            case 1:
                contactPressed()
            default:
                print("no action")
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
