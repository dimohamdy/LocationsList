//
//  LocationsListBuilder.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

struct AddLocationBuilder {

    static func viewController(localLocationRepository: LocalLocationRepository = UserDefaultLocalLocationRepository.shared) -> AddLocationViewController {
        let presenter = AddLocationPresenter(localLocationRepository: localLocationRepository)
        let viewController: AddLocationViewController = AddLocationViewController(presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
