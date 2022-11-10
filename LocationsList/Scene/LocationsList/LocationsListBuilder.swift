//
//  LocationsListBuilder.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

struct LocationsListBuilder {

    static func viewController(presenter: LocationsListPresenter = LocationsListPresenter(),
                               router: LocationsListRouter = LocationsListRouter()) -> LocationsListViewController {
        let viewController: LocationsListViewController = LocationsListViewController(presenter: presenter, router: router)
        presenter.output = viewController

        router.viewController = viewController

        return viewController
    }
}
