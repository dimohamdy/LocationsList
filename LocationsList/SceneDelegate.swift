//
//  SceneDelegate.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        Reachability.shared.startNetworkReachabilityObserver()
        EntryPoint().initSplashScreen(window: window!)
    }

}

