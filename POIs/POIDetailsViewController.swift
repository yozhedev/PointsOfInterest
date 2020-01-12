//
//  POIDetailsViewController.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class POIDetailsViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var ratingView: RatingView!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel         : UILabel!
    @IBOutlet weak var leadParagraphLabel : UILabel!
    @IBOutlet weak var descriptionLabel   : UILabel!
    @IBOutlet weak var photosLabel        : UILabel!
    
    @IBOutlet weak var headerImageViewHeight        : NSLayoutConstraint!
    @IBOutlet weak var headerImageViewTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint      : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight         : NSLayoutConstraint!
    
    
    // MARK: Variables
    
    var pointOfInterest: PointOfInterest!
    
    private var _imageCache = NSCache<NSString, UIImage>()
    
    private var _statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    // MARK: Constants
    
    private let kOriginalImageHeight           : CGFloat = UIScreen.main.bounds.size.height * 0.35
    private let kOriginalTitleLabelTopDistance : CGFloat = 20.0
    
    private let kPhotoCellIdentifier = "photoCell"
    private let kContentSizeKeyPath  = "contentSize"
    
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return _statusBarStyle
    }
    
    
    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setForWhiteBackGround()
        
        self.scrollView.delegate             = self
        self.photosCollectionView.delegate   = self
        self.photosCollectionView.dataSource = self
        
        self.configureInitialTheme()
        self.setData()
        
        self.photosCollectionView.addObserver(self, forKeyPath: kContentSizeKeyPath, options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if
            let observedObject = object as? UICollectionView,
            observedObject == self.photosCollectionView,
            let newHeight = (change?.values.first(where: {$0 is CGSize}) as? CGSize)?.height {
                self.photosCollectionView.removeObserver(self, forKeyPath: kContentSizeKeyPath)
                
                //satisfy any runtime constraints ambiguity between the scrollview and the collection view
                self.collectionViewHeight.constant = newHeight
            
                self.photosLabel.isHidden = newHeight < 1
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.photosCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: Private Methods
    
    private func configureInitialTheme() {
        self.headerImageViewTopConstraint.constant -= self.navigationHeight
        
        if let _ = self.pointOfInterest.mainImage {
            self.headerImageView.image = self.pointOfInterest.mainImage
            
            self.navigationController?.setToTransparent()
            self._statusBarStyle = .lightContent
              
            self.headerImageViewHeight  .constant = self.kOriginalImageHeight
            self.titleLabelTopConstraint.constant = self.kOriginalImageHeight + self.kOriginalTitleLabelTopDistance

            self.scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
           
            return
        }

        self.headerImageViewHeight  .constant = 0.0
        self.titleLabelTopConstraint.constant = self.kOriginalTitleLabelTopDistance
    }
    
    private func setData() {
        self.titleLabel.text         = self.pointOfInterest.title
        self.leadParagraphLabel.text = self.pointOfInterest.leadParagraph
        self.descriptionLabel.text   = self.pointOfInterest.description
        self.ratingView.rating       = self.pointOfInterest.reviewAvg
    }
    
    
    // MARK: Helpers
    
    private var navigationHeight: CGFloat {
        let navigationHeight = self.navigationController?.navigationBar.frame.height ?? 44.0
        let statusBarHeight  = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        return navigationHeight + statusBarHeight
    }
    
}

extension POIDetailsViewController: UIScrollViewDelegate {
    
    // MARK: Scroll View Source
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let _ = self.headerImageView.image else {
            return
        }
        
        let offset     : CGFloat = scrollView.contentOffset.y
        let defaultTop : CGFloat = 0.0
        var currentTop : CGFloat = defaultTop
        
        if offset < 0 {
            currentTop = offset
            self.headerImageViewHeight.constant = kOriginalImageHeight - offset
        } else if kOriginalImageHeight - offset < self.navigationHeight {
            self.headerImageViewHeight.constant = offset + self.navigationHeight
        } else {
            self.headerImageViewHeight.constant = kOriginalImageHeight
        }

        self.headerImageViewTopConstraint.constant = currentTop
    }
    
}

extension POIDetailsViewController: UICollectionViewDataSource {
    
    // MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pointOfInterest.poiImages.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPhotoCellIdentifier, for: indexPath)
        
        if let poiCell = cell as? POICollectionViewCell {
            poiCell.setUp(withImageData: self.pointOfInterest.poiImages[indexPath.item + 1], cache: _imageCache)
        }
        
        return cell
    }

}

extension POIDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        
        let height = (self.photosCollectionView.frame.width / 3) - (minSpacing * 2)
        
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DefaultSizes.CollectionView.minInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DefaultSizes.CollectionView.minLineSpacing
    }
    
}

