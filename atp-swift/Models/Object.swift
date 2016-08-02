//
//  Object.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 20.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import ObjectMapper

class Object: Mappable {
    
    // MARK: - Properties

    var id: Int?
    
    init(id : Int) {
        self.id = id
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
}