//
//  Place.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 25.6.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import CoreLocation
import ObjectMapper

class Place: Object {
    
    // MARK: - Properties

    var name: String?
    var overview: String?
    var country: String?
    var city: String?
    var address: String?
    var latitude: CLLocationDegrees?
    var longtitude: CLLocationDegrees?
    var imageURL: NSURL?

    var coordinate: CLLocationCoordinate2D {
        guard latitude != nil && longtitude != nil else {
            return kCLLocationCoordinate2DInvalid
        }
        return CLLocationCoordinate2DMake(latitude!, longtitude!)
    }
    
    init(name: String?, country: String?, city: String?, coordinate: CLLocationCoordinate2D?, imageURL: NSURL?) {
        super.init(id: 0)

        self.name = name
        self.country = country
        self.city = city
        //self.coordinate = coordinate
        self.imageURL = imageURL
    }
    
    convenience init(name: String, coordinate: CLLocationCoordinate2D, imageURL: NSURL) {
        self.init(name: name, country: nil, city: nil, coordinate: coordinate, imageURL: imageURL)
    }

    required init?(_ map: Map) {
        super.init(map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map)
        
        name        <- map["name"]
        overview    <- map["overview"]
        country     <- map["country"]
        city        <- map["city"]
        latitude    <- map["location.lat"]
        longtitude  <- map["location.lon"]
        imageURL    <- (map["image_url"], URLTransform())
    }
    
}