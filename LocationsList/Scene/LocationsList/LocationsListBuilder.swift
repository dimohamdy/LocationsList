//
//  LocationsListBuilder.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

struct LocationsListBuilder {
    
    static func viewController() -> LocationsListViewController {
        let router = LocationsListRouter()

        let viewController: LocationsListViewController = LocationsListViewController(router: router)
        let presenter = LocationsListPresenter(output: viewController)
        viewController.presenter = presenter

        router.viewController = viewController

        return viewController
    }
}
