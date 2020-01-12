//
//  LocationManager.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    // MARK: Variables
    
    weak var delegate: LocationManagerDelegate?
    
    private var currentLocation: CLLocation?
    
    // MARK: Constants
    
    private let locationManager = CLLocationManager()
    
    
    // MARK: Singleton
    
    static let shared = LocationManager()
    
    
    // MARK: Public Methods
    
    func startGettingLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        self.locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.startUpdatingLocation()
    }
    
    func stopGettingLocation() {
        self.locationManager.stopUpdatingLocation()
        
        self.locationManager.delegate = nil
    }
    
    func findDistanceInKm(toLocationWith latitude: Double, longitude: Double) -> Double? {
        guard let currLocation = self.currentLocation else {
            return nil
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        return currLocation.distance(from: location) / 1000.0
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.startGettingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        self.currentLocation = location
        
        self.delegate?.didUpdateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.failed(withError: error)
    }
    
}

protocol LocationManagerDelegate: class {
    
    func didUpdateLocation()
    func failed(withError error: Error)
    
}

