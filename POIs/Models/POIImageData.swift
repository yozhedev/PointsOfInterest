//
//  POIImageData.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation

class POIImageData {
    
    // MARK: Variables
    
    var id       : Int
    var position : Int
    
    var caption   : String
    var copyright : String?
    var url       : String
    
    
    // MARK: Initialisers
    
    init(json: JSON) {
        self.caption   = json.safeString(forKey: "caption")
        self.copyright = json["copyright"] as? String //can be null from endpoint
        self.id        = json.safeInt(forKey: "id")
        self.url       = json.safeString(forKey: "image_url")
        self.position  = json.safeInt(forKey: "position")
    }
    
}
