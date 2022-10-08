//
//  LocalLocationRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

protocol LocalLocationRepositoryUpdate: AnyObject {
    func updated(localLocations: [Location])
}

protocol LocalLocationRepository: LocationsRepository {
    var delegate: LocalLocationRepositoryUpdate? { get set }
    
    func save(location: Location)
    func remove(location: Location)
}
