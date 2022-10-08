//
//  UserDefaultLocalLocationRepositoryTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import XCTest
@testable import LocationsList

final class UserDefaultLocalLocationRepositoryTests: XCTestCase {
    var localLocationRepository: UserDefaultLocalLocationRepository!
    private var userDefaults: UserDefaults!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        localLocationRepository = UserDefaultLocalLocationRepository(userDefaults: userDefaults)
        _ = localLocationRepository.clearLocations()
    }
    
    func testGetItemsFromAPI() {
        // Act: get data from API .
        localLocationRepository.save(location: Location(name: "Cairo", lat: 12.3333, long: 34.44444))
        localLocationRepository.save(location: Location(name: "Amsterdam", lat: 55.3333, long: 25.44444))
        localLocationRepository.save(location: Location(name: "Spain", lat: 33.3333, long: 65.44444))
        localLocationRepository.save(location: Location(name: "Berlin", lat: 77.3333, long: 43.44444))
        let locations = localLocationRepository.getLocations()
        // Assert: Verify it's have a data.
        XCTAssertEqual(locations.count, 4)
        
    }
}
