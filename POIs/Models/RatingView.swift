//
//  RatingView.swift
//  POIs
//
//  Created by MacBook Pro on 10.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class RatingView: UIView {

    // MARK: Outlets
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet var ratingStarsImageViews: [UIImageView]!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    // MARK: Variables
    
    var rating: Int? {
        didSet {
            self.setData()
        }
    }
    
    
    // MARK: Initialisers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.customInit()
    }
    
    
    // MARK: Private Methods
    
    private func customInit() {
        Bundle.main.loadNibNamed(String(describing: RatingView.classForCoder()), owner: self, options: nil)
        self.addSubview(self.mainView)
        self.mainView.frame = self.bounds
    }
    
    private func setData() {
        guard let rating = self.rating else {
            return
        }
        
        self.ratingLabel.text = "(\(rating))"
        
        for i in 0..<self.ratingStarsImageViews.count {
            self.ratingStarsImageViews[i].image = rating > i ? #imageLiteral(resourceName: "largeFilledStarIcon.png") : #imageLiteral(resourceName: "largeUnfilledStarIcon.png")
        }
        
        self.layoutIfNeeded()
    }
    
}
