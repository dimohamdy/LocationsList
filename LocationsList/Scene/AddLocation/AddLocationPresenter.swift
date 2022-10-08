//
//  AddLocationPresenter.swift
//  AddLocation
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

protocol AddLocationPresenterInput: BasePresenterInput {
    func add(location: Location)
    func validate(latitude: Double) -> Bool
    func validate(longitude: Double) -> Bool
}

protocol AddLocationPresenterOutput: BasePresenterOutput {
    func addLocation(success: Bool)
}

final class AddLocationPresenter {

    // MARK: Injections
    private weak var output: AddLocationPresenterOutput?
    let localLocationRepository: LocalLocationRepository

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

    // Validate long and lat https://stackoverflow.com/a/7780993/3806350
    func validate(latitude: Double) -> Bool {
        let latitudeRange = -90.0 ... 90.0
        return latitudeRange.contains(latitude)
    }

    func validate(longitude: Double) -> Bool {
        let longitudeRange = -180.0 ... 180.0
        return longitudeRange.contains(longitude)
    }
}
