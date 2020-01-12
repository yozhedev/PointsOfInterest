//
//  NetworkingServoce+PointOfInterest.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation

extension NetworkingService {
    
    func fetchPOIs(completion: @escaping (([PointOfInterest]) -> Void)) {
        self.request(EndPoints.POIendPoint) { result in
            switch result {
            case .success(let data):
                var pointsOfInterest: [PointOfInterest] = []
                
                data.poisJson?.forEach { poiJson in
                    pointsOfInterest.append(PointOfInterest(json: poiJson))
                }
                
                completion(pointsOfInterest)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
        
    }
    
}
