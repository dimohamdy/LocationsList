//
//  LocationsRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

protocol LocationsRepository {

    func getLocations() async throws -> [Location]
}
