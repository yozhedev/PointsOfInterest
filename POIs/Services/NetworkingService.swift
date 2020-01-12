//
//  NetworkingService.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation

class NetworkingService {
    
    func request(_ urlPath: String, completion: @escaping (Result<Data, NSError>) -> Void) {
        let url     = URL(string: urlPath)!
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, _, error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else if let unwrappedData = data {
                completion(.success(unwrappedData))
            }
        }
        
        task.resume()
    }
    
}
