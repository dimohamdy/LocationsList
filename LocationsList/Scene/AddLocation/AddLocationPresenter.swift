//
//  AddLocationPresenter.swift
//  AddLocation
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

protocol AddLocationPresenterInput: BasePresenterInput {
    func add(location: Location)
}

protocol AddLocationPresenterOutput: BasePresenterOutput {
    func addLocation(success: Bool)
}

final class AddLocationPresenter {

    // MARK: Injections
    private weak var output: AddLocationPresenterOutput?
    let localLocationRepository: LocalLocationRepository

    // internal
    private var locationsSections: [ItemTableViewCellType] = [ItemTableViewCellType]()

    // MARK: Init
    init(output: AddLocationPresenterOutput,
         localLocationRepository: LocalLocationRepository) {

        self.output = output
        self.localLocationRepository = localLocationRepository
    }
}

// MARK: - AddLocationPresenterInput
extension AddLocationPresenter: AddLocationPresenterInput {

    func add(location: Location) {
        localLocationRepository.save(location: location)
        output?.addLocation(success: true)
    }
}
