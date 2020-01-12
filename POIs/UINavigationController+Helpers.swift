//
//  UINavigationController+Helpers.swift
//  POIs
//
//  Created by MacBook Pro on 10.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setToTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = .white
    }
    
    func setForWhiteBackGround() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .systemBlue
    }
    
}
