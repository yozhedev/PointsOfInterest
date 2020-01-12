//
//  PointOfInterest.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation
import UIKit

class PointOfInterest {
    
    // MARK: Variables
    
    var id: Int
    
    var title         : String
    var leadParagraph : String
    var description   : String
    var updatedAt     : String
    var createdAt     : String
    
    var latitude  : Double
    var longitude : Double
    var radius    : Double
    
    var reviewAvg: Int
    
    var poiImages: [POIImageData] = []
    
    //storing this image in the object so we save bandwidth from additional network calls
    //and having to load the image immediately on the details screen avoids redrawing
    //constraints after the view controller appeared as some of its constraints
    //depend on the header imageView having or not having an image
    var mainImage: UIImage?
    
    
    // MARK: Initialisers
    
    init(json: JSON) {
        self.id            = json.safeInt(forKey: "id")
        self.title         = json.safeString(forKey: "title")
        self.leadParagraph = json.safeString(forKey: "lead_paragraph")
        self.description   = json.safeString(forKey: "description")
        self.latitude      = json.safeDouble(forKey: "latitude")
        self.longitude     = json.safeDouble(forKey: "longitude")
        self.radius        = json.safeDouble(forKey: "radius")
        self.reviewAvg     = json.safeInt(forKey: "review_average")
        self.updatedAt     = json.safeString(forKey: "updated_at")
        self.createdAt     = json.safeString(forKey: "created_at")
        
        json.safeArray(forKey: "images").forEach { imageJson in
            self.poiImages.append(POIImageData(json: imageJson))
        }
    }
    
    
    // MARK: Helpers
    
    var distance: Double {
        return LocationManager.shared.findDistanceInKm(toLocationWith: self.latitude, longitude: self.longitude) ?? self.radius
    }
    
}
