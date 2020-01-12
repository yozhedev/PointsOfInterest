//
//  POICollectionViewCell.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class POICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    func setUp(withPOI poi: PointOfInterest, cache: NSCache<NSString, UIImage>) {
        self.titleLabel   .text = poi.title
        self.distanceLabel.text = String(format: "%.01f KM", poi.distance)
        
        self.contentView.layer.cornerRadius  = 10
        self.contentView.layer.masksToBounds = true
        self.bgImageView.load(fromUrl: poi.poiImages.first?.url ?? "", imageCache: cache) {
            poi.mainImage = self.bgImageView.image
        }
    }
    
    func setUp(withImageData data: POIImageData, cache: NSCache<NSString, UIImage>) {
        self.contentView.layer.cornerRadius  = 10
        self.contentView.layer.masksToBounds = true
        
        self.bgImageView.load(fromUrl: data.url, imageCache: cache)
    }
    
}
