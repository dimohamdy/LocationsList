//
//  LocalLocationRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

protocol LocalLocationRepository: LocationsRepository {
    func save(location: Location)
    func remove(location: Location)
}
