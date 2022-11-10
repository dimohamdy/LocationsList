//
//  WebLocationsRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

final class WebLocationsRepository: LocationsRepository {

    let client: APIClient

    init(client: APIClient = APIClient()) {
        self.client = client
    }

    func getLocations() async throws -> [Location] {
        guard let path = APILinksFactory.API.locations.path,
              let url = URL(string: path) else {
            throw LocationsListError.wrongURL
        }
        // return the value from try direct without set it in another value  
        let result: LocationsResult = try await client.loadData(from: url)
        return result.locations
    }
}
