//
//  CustomLoadingView.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class CustomLoadingView: UIView {
    
    // MARK: Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    // MARK: Variables
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "app-icon-transperant"))
        imageView.contentMode = .scaleAspectFit
        imageView.center = self.center
        
        return imageView
    }()
    
    
    // MARK: Public Methods
    
    func startAnimating() {
        self.imageView.rotate()
        self.addSubview(self.imageView)
    }
    
}
