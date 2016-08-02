//
//  APIClient.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 25.6.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class APIClient {
    
    static func getFeaturedItineraries(completion: ([Itinerary]?, NSError?) -> Void) {
        //@daniel: this returns dummy local data. in final project this will return real network data

        guard let path = NSBundle.mainBundle().pathForResource("explore-itineraries", ofType: "json") else {
            print("Invalid json file path.")
            return
        }
        
        do {
            let jsonString = try String(contentsOfFile: path)
            let itineraries = Mapper<Itinerary>().mapArray(jsonString)
            completion(itineraries, nil)
        } catch {
            
        }
    }
    
    static func loginWithUsername(username: String, password: String, completion: (User?, NSError?) -> Void) {
       //@daniel: this returns dummy local data. in final project this will return real network data
        
        let user: User = User(id: 1)
        user.name = username
        user.password = password
        
        completion(user, nil)
    }
    
    static func signupWithUsername(username: String, password: String, avatar: UIImage?, completion: (User?, NSError?) -> Void) {
        //@daniel: this returns dummy local data. in final project this will return real network data
        
        let user: User = User(id: 1)
        user.name = username
        user.password = password
        user.image = avatar
        
        completion(user, nil)
    }
}