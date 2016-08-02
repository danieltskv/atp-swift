//
//  ItineraryMapVC.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 22.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import GoogleMaps

class ItineraryMapVC: UIViewController, GMSMapViewDelegate {

    // MARK: Properties

    var mapView: GMSMapView?
    var itinerary: Itinerary?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.itinerary?.name ?? NSLocalizedString("Itinerary", comment: "")
        //self.title = NSLocalizedString("Map", comment: "")
        
        let coordinate = itinerary?.center() ?? CLLocationCoordinate2DMake(0, 0)
        let camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 12)
        
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        self.mapView!.settings.myLocationButton = true
        self.mapView!.settings.compassButton = true
        self.mapView!.delegate = self
        self.view = self.mapView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        showItineraryOnMap()
    }

    // MARK: - Convenience

    func showItineraryOnMap() {
        guard let pois =  self.itinerary?.pois else {
            return
        }
        
        self.mapView?.clear()
        
        //let bounds = GMSCoordinateBounds()
        let path = GMSMutablePath()
        
        for i in 0 ..< pois.count {
            
            let place: Place = pois[i]
            
            guard CLLocationCoordinate2DIsValid(place.coordinate) else {
                continue
            }
            
            let marker = GMSMarker()
            marker.position = place.coordinate
            marker.title = String(format: "#%d %@", i+1, place.name ?? "")
            marker.snippet = String(format: "%.6f, %.6f", place.coordinate.latitude, place.coordinate.longitude)
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.userData = place;
            //marker.icon = GMSMarker.markerImageWithColor(UIColor(red: 32/255.0, green: 149/255.0, blue: 248/255.0, alpha: 1.0)) //UIImage(named: "ic_place_36pt")
            marker.map = self.mapView
            
            //bounds.includingCoordinate(marker.position)
            path.addCoordinate(place.coordinate)
            
            let polyline: GMSPolyline = GMSPolyline(path: path)
            polyline.strokeColor = UIColor.grayColor()
            polyline.strokeWidth = 2.0
            polyline.map = self.mapView
        }
        
        let pathBounds = GMSCoordinateBounds(path: path)
        //print("\(pathBounds.southWest)")
        
        let cameraUpdate: GMSCameraUpdate = GMSCameraUpdate.fitBounds(pathBounds, withPadding: 50.0)
        self.mapView!.moveCamera(cameraUpdate)
    }
    
}
