//
//  PlaceVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 22.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import MapKit

class PlaceVC: UITableViewController {

    // MARK: Properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    var place: Place? {
        didSet {
            //setupPlace()
        }
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPlace()
    }
    
    // MARK: - Convenience

    func setupPlace() {
        
        self.title = place!.name
        
        if place!.imageURL != nil {
            self.imageView.sd_setImageWithURL(place!.imageURL)
        }
        
        self.addressLabel.text = place?.address ?? "—"
        self.hoursLabel.text = place?.overview ?? "—"
    }
    
    func didPressNavigate() {
        guard CLLocationCoordinate2DIsValid(self.place!.coordinate) else {
            return
        }
        
        let coordinate = self.place?.coordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate!, addressDictionary:nil))
        mapItem.name = place!.name
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 3 {
            didPressNavigate()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
