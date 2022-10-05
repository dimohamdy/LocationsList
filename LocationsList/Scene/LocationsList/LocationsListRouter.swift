//
//  LocationsListRouter.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

class LocationsListRouter {
    weak var viewController: LocationsListViewController?

    func navigateToAddLocation() {
        let addLocationViewController = AddLocationBuilder.viewController()
        viewController?.navigationController?.pushViewController(addLocationViewController, animated: true)
    }
}
