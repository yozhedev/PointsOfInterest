//
//  UIImage+Helpers.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func load(fromUrl urlString: String, imageCache: NSCache<NSString, UIImage>, completion: (() -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
                completion?()
            }
            
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard
                let data  = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self?.image = image
                completion?()
            }
        }
    }
    
}
