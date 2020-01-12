//
//  Data+JSON.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import Foundation

extension Data {
    
    var poisJson: [JSON]? {
        do {
            guard let jsonArray = try JSONSerialization.jsonObject(with: self, options: []) as? [JSON] else {
                print("JSON serialization failed")
                return nil
            }
            
            return jsonArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
