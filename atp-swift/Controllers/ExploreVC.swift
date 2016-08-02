//
//  ExploreViewController.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 25.6.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import CoreLocation.CLLocation
import SDWebImage

class ExploreVC: UITableViewController {
    
    // MARK: - Properties
    
    var itineraries: [Itinerary]?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)

        loadAndShowItineraries()
    }
    
    // MARK: - Class Methods

    func loadAndShowItineraries() {
        APIClient.getFeaturedItineraries { itineraries, error in
            
            if itineraries != nil {
                //print("featured itineraries \(itineraries!.count)")
                self.itineraries = itineraries
                self.tableView.reloadData()
            }
            
            //dump(itineraries)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard itineraries != nil else {
            return 0
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard itineraries != nil else {
            return 0
        }
        
        return itineraries!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itineraryCellFull", forIndexPath: indexPath)
        
        let itinerary: Itinerary = itineraries![indexPath.row]
        let destination = itinerary.destination!
        
        if let cityLabel = self.view.viewWithTag(1) as? UILabel {
            cityLabel.text = destination.city
        }
        
        if let countryLabel = self.view.viewWithTag(2) as? UILabel {
            if let country = destination.country {
                countryLabel.text = country
            }
            
        }
  
        
        if let imageView = self.view.viewWithTag(3) as? UIImageView {
            if destination.imageURL != nil {
                imageView.sd_setImageWithURL(destination.imageURL, placeholderImage: UIImage.init(named: "ic_insert_photo_48pt"))
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toItinerary" {
            let vc = segue.destinationViewController as! ItineraryListVC
            //vc.hidesBottomBarWhenPushed = true
            
            let itinerary: Itinerary = itineraries![self.tableView.indexPathForSelectedRow!.row]
            vc.itinerary = itinerary
        }
    }
}
