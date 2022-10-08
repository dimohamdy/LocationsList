//
//  LocationsListViewControllerTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
import XCTest
@testable import LocationsList

final class LocationsListViewControllerTests: XCTestCase {
    var locationsListViewController: LocationsListViewController!
    var localLocationRepository: UserDefaultLocalLocationRepository!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        localLocationRepository = UserDefaultLocalLocationRepository(userDefaults: userDefaults)

        locationsListViewController =  LocationsListBuilder.viewController()        
        // Arrange: setup UINavigationController
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = UINavigationController(rootViewController: locationsListViewController)
    }
    
    override func tearDown() {
        locationsListViewController = nil
        _ = localLocationRepository.clearLocations()
        
    }
    
    func test_getLocations_success() {
        let expectation = XCTestExpectation()
        
        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        let presenter = LocationsListPresenter(output: locationsListViewController,
                                               locationsRepository: repository,
                                               localLocationRepository: localLocationRepository)
        locationsListViewController.presenter = presenter
        
        // fire getLocations after load viewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presenter.getLocation()
            
        }
        
        // Check the datasource after getLocations result bind to TableView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertNotNil(self.locationsListViewController.tableDataSource)
            XCTAssertNotNil(self.locationsListViewController.tableDataSource?.presenterInput)
            XCTAssertEqual(self.locationsListViewController.tableDataSource?.tableSections.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_localLocation_success() {
        let expectation = XCTestExpectation()

        let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        let presenter = LocationsListPresenter(output: locationsListViewController,
                                               locationsRepository: repository,
                                               localLocationRepository: localLocationRepository)
        locationsListViewController.presenter = presenter
        
        localLocationRepository.save(location: Location(name: "Cairo", lat: 12.3333, long: 34.44444))
        localLocationRepository.save(location: Location(name: "Amsterdam", lat: 55.3333, long: 25.44444))
        localLocationRepository.save(location: Location(name: "Spain", lat: 33.3333, long: 65.44444))
        localLocationRepository.save(location: Location(name: "Berlin", lat: 77.3333, long: 43.44444))
        
        locationsListViewController.presenter?.getLocation()
        
        // Check the datasource after getLocations result bind to TableView
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            XCTAssertNotNil(self.locationsListViewController.tableDataSource)
            XCTAssertNotNil(self.locationsListViewController.tableDataSource?.presenterInput)
            XCTAssertEqual(self.locationsListViewController.tableDataSource?.tableSections.count, 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func getMockWebLocationsRepository(mockSession: URLSessionMock) -> WebLocationsRepository {
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebLocationsRepository(client: mockAPIClient)
    }
}
