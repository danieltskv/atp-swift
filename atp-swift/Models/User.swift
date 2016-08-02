//
//  User.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 27.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Object {

    // MARK: - Properties

    var name: String?
    var email: String?
    var password: String?
    var imageURL: NSURL?
    var image: UIImage?

    var itineraries: [Itinerary]?
    
    override init(id : Int) {
        super.init(id: id)
    }
    
    required init?(_ map: Map) {
        super.init(map)
    }
    
    // Mappable
    override func mapping(map: Map) {
        super.mapping(map)
        
        name        <- map["name"]
        email       <- map["email"]
        password    <- map["password"]
        imageURL    <- (map["image_url"], URLTransform())
        itineraries <- map["itineraries"]
    }
    
    func addItinerary(itinerary: Itinerary) {
        if self.itineraries != nil {
            self.itineraries?.append(itinerary)
        } else {
            self.itineraries = [itinerary]
        }
    }
    
    func removeItinerary(itinerary: Itinerary) {
        if self.itineraries == nil {
            return
        }
        
        let index = self.itineraries!.indexOf{$0 === itinerary}
        
        if index != nil {
            self.itineraries!.removeAtIndex(index!)
        }
    }
}
