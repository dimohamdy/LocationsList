//
//  LocationsListViewControllerTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
import SnapshotTesting
@testable import LocationsList
import XCTest

final class LocationsListViewControllerTests: XCTestCase {
    var locationsListViewController: LocationsListViewController!
    var localLocationRepository: UserDefaultLocalLocationRepository!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        localLocationRepository = UserDefaultLocalLocationRepository(userDefaults: userDefaults)
    }

    override func tearDown() {
        locationsListViewController = nil
        _ = localLocationRepository.clearLocations()
    }

    func test_snapshot_get_onlineLocation_localLocation_success() {
        let expectation = XCTestExpectation()

        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        let presenter = LocationsListPresenter(locationsRepository: repository,
                                               localLocationRepository: localLocationRepository)
        presenter.output = locationsListViewController

        localLocationRepository.save(location: Location(name: "Cairo", lat: 12.3333, long: 34.44444))
        localLocationRepository.save(location: Location(name: "Amsterdam", lat: 55.3333, long: 25.44444))
        localLocationRepository.save(location: Location(name: "Spain", lat: 33.3333, long: 65.44444))
        localLocationRepository.save(location: Location(name: "Berlin", lat: 77.3333, long: 43.44444))

        setVC(presenter: presenter)
        presenter.getLocation()

        // Check the datasource after getLocations result bind to TableView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in

            assertSnapshot(matching: locationsListViewController, as: .image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
    }



    func test_snapshot_getData_online() {
        let expectation = XCTestExpectation()

        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        let presenter = LocationsListPresenter(locationsRepository: repository,
                                               localLocationRepository: localLocationRepository)
        setVC(presenter: presenter)
        presenter.getLocation()

        // Check the datasource after getLocations result bind to TableView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            assertSnapshot(matching: locationsListViewController, as: .image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)

    }
}

extension LocationsListViewControllerTests {

    func getMockWebLocationsRepository(mockSession: URLSessionMock) -> WebLocationsRepository {
        let mockAPIClient = APIClient(withSession: mockSession)
        return WebLocationsRepository(client: mockAPIClient)
    }

    func setVC(presenter: LocationsListPresenter) {
        locationsListViewController = LocationsListBuilder.viewController(presenter: presenter)
    }
}
