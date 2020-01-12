//
//  UIView+Helpers.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: Public Methods
    
    func rotate(duration     : CFTimeInterval = 2,
                isCumulative : Bool           = true,
                repeatCount  : Float          = Float.greatestFiniteMagnitude) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue      = NSNumber(value: Double.pi * 2)
        rotation.duration     = duration
        rotation.isCumulative = isCumulative
        rotation.repeatCount  = repeatCount
        
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func showLoading() {
        let loadingView = CustomLoadingView(frame: self.bounds)
        
        loadingView.tag = self.loadingViewTag
        DispatchQueue.main.async {
            loadingView.startAnimating()
            self.addSubview(loadingView)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.viewWithTag(self.loadingViewTag)?.removeFromSuperview()
        }
    }
    
    
    // MARK: Helpers
    
    private var loadingViewTag: Int {
        return 9999
    }
    
}
