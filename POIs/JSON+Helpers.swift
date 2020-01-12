//
//  JSON+Helpers.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]

extension JSON {
    
    // MARK: Public Methods
    
    func safeString(forKey key: String) -> String {
        return self[key] as? String ?? ""
    }
    
    func safeInt(forKey key: String) -> Int {
        return self[key] as? Int ?? -1
    }
    
    func safeDouble(forKey key: String) -> Double {
        return self[key] as? Double ?? 0.0
    }
    
    func safeArray<T>(forKey key: String) -> Array<T> {
        return self[key] as? Array ?? []
    }
    
}
