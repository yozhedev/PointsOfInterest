//
//  MainNavigationController.swift
//  POIs
//
//  Created by MacBook Pro on 10.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topViewController = viewControllers.last {
            return topViewController.preferredStatusBarStyle
        }

        return .default
    }
    
}
