//
//  POIsListViewController.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class POIsListViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: Variables
    
    private var _pointsOfInterest: [PointOfInterest] = []
    
    private var _imageCache = NSCache<NSString, UIImage>()
    
    
    // MARK: Constants
    
    private let kCompactCellIdentifier          = "POICompactCell"
    private let kPOICellIdentifier              = "POICell"
    private let kCollectionViewHeaderIdentifier = "collectionViewHeader"
    private let kPOIDetailsControllerIdentifier = "POIDetailsViewController"
    
    
    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setToTransparent()
        
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        
        LocationManager.shared.delegate = self
        
        self.view.showLoading()
        
        let networking = NetworkingService()
        networking.fetchPOIs(completion: { pois in
            self._pointsOfInterest = pois.sorted(by: {$0.distance < $1.distance})
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.hideLoading()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    deinit {
        LocationManager.shared.delegate = nil
    }
    
}

extension POIsListViewController: UICollectionViewDataSource {
    
    // MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _pointsOfInterest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let compactCell  = collectionView.dequeueReusableCell(withReuseIdentifier: kCompactCellIdentifier, for: indexPath)
        let expandedCell = collectionView.dequeueReusableCell(withReuseIdentifier: kPOICellIdentifier, for: indexPath)
        
        if let poiCell = expandedCell as? POICollectionViewCell, indexPath.item == 0 {
            poiCell.setUp(withPOI: _pointsOfInterest[indexPath.item], cache: _imageCache)
            return expandedCell
        }
        
        if let poiCell = compactCell as? POICollectionViewCell {
            poiCell.setUp(withPOI: _pointsOfInterest[indexPath.item], cache: _imageCache)
        }
        
        return compactCell
    }
    
}

extension POIsListViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        
        let height = (self.collectionView.frame.width / 2) - minSpacing
        
        if indexPath.item == 0 {
            return CGSize(width: self.collectionView.frame.width, height: height)
        }
        
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return DefaultSizes.CollectionView.minInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DefaultSizes.CollectionView.minLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCollectionViewHeaderIdentifier, for: indexPath)
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return header
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(identifier: kPOIDetailsControllerIdentifier) as? POIDetailsViewController {
            controller.pointOfInterest = _pointsOfInterest[indexPath.item]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

extension POIsListViewController: LocationManagerDelegate {
    
    // MARK: Location Manager Delegate
    
    func didUpdateLocation() {
        LocationManager.shared.stopGettingLocation()
        
        let networking = NetworkingService()
        networking.fetchPOIs(completion: { pois in
            self._pointsOfInterest = pois.sorted(by: {$0.distance < $1.distance})
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.view.hideLoading()
            }
        })
    }
    
    func failed(withError error: Error) {
        let alert = UIAlertController(title: "Error:", message: "\(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
