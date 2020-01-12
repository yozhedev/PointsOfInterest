//
//  SceneDelegate.swift
//  POIs
//
//  Created by MacBook Pro on 9.01.20.
//  Copyright © 2020 yovkozhelev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let storyboard           = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(identifier: "MainNavigationController")
        
        self.window                     = UIWindow(frame: windowScene.coordinateSpace.bounds)
        self.window?.windowScene        = windowScene
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        //Uncomment to show distance from current location
        
        //LocationManager.shared.startGettingLocation()
    }

}
