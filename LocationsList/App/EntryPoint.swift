//
//  EntryPoint.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

struct EntryPoint {

    func initSplashScreen(window: UIWindow) {
        window.rootViewController = UINavigationController(rootViewController: LocationsListBuilder.viewController())
        window.makeKeyAndVisible()
    }

}
