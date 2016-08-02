//
//  Itinerary.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 25.6.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import ObjectMapper
import GoogleMaps

enum Visibility: String {
    case Private = "private"
    case Public  = "public"
}

class Itinerary: Object {
    
    // MARK: - Properties

    var name: String?
    var overview: String?
    var destination: Place?
    var pois: [Place]?
    var imageURL: NSURL?
    
    var userNotes: String?
    var visibility: Visibility = .Private

    init(name: String, overview: String, destination: Place) {
        super.init(id: 0)

        self.name = name
        self.overview = overview
        self.destination = destination
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map)
        
        name        <- map["name"]
        overview    <- map["overview"]
        destination <- map["destination"]
        pois        <- map["pois"]
        imageURL    <- (map["image_url"], URLTransform())
        userNotes   <- map["userNotes"]
        visibility  <- (map["visibility"], EnumTransform<Visibility>())
    }
    
    func center() -> CLLocationCoordinate2D {
        guard pois != nil else {
            return CLLocationCoordinate2D()
        }
        
        let bounds = GMSCoordinateBounds()
        
        for place in pois! {
            guard CLLocationCoordinate2DIsValid(place.coordinate) else {
                continue
            }
            bounds.includingCoordinate(place.coordinate)
        }
        
        return GMSGeometryInterpolate(bounds.northEast, bounds.southWest, 0.5);
    }
}
