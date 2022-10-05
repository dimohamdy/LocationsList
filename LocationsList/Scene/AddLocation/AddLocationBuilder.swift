//
//  LocationsListBuilder.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

struct AddLocationBuilder {
    
    static func viewController(localLocationRepository: LocalLocationRepository = UserDefaultLocalLocationRepository.shared) -> AddLocationViewController {
        let viewController: AddLocationViewController = AddLocationViewController()
        let presenter = AddLocationPresenter(output: viewController, localLocationRepository: localLocationRepository)
        viewController.presenter = presenter
        return viewController
    }
}
