//
//  LocationsListPresenterTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import XCTest

final class LocationsListPresenterTests: XCTestCase {
    var mockLocationsListPresenterOutput: MockLocationsListPresenterOutput!
    private var userDefaults: UserDefaults!
    private var reachability: Reachable!

    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)

        mockLocationsListPresenterOutput = MockLocationsListPresenterOutput()
    }

    override func tearDown() {
        mockLocationsListPresenterOutput = nil
        reachability = MockReachability(internetConnectionState: .satisfied)
    }

    func test_getLocations_success() {
        let expectation = XCTestExpectation()

        let presenter = getLocationsListPresenter(fromJsonFile: "data")
        presenter.getLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            XCTAssertEqual(mockLocationsListPresenterOutput.tableSections.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func test_getLocations_noResult() {
        let expectation = XCTestExpectation()

        let presenter = getLocationsListPresenter(fromJsonFile: "noData")
        presenter.getLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            XCTAssertEqual(mockLocationsListPresenterOutput.tableSections.count, 0)
            if let error = mockLocationsListPresenterOutput.error as? LocationsListError {
                switch error {
                case .noResults:
                    XCTAssertTrue(true)
                default:
                    XCTFail("the error isn't noResults")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func test_getLocations_noInternetConnection() {
        reachability = MockReachability(internetConnectionState: .unsatisfied)
        let presenter = getLocationsListPresenter(fromJsonFile: "noData")
        presenter.getLocation()
        XCTAssertEqual(mockLocationsListPresenterOutput.tableSections.count, 0)
        if let error = mockLocationsListPresenterOutput.error as? LocationsListError {
            switch error {
            case .noInternetConnection:
                XCTAssertTrue(true)
            default:
                XCTFail("the error isn't noResults")
            }
        }
    }

    private func getMockWebLocationsRepository(mockSession: URLSessionMock) -> WebLocationsRepository {
        let mockAPIClient = APIClient(withSession: mockSession)
        return WebLocationsRepository(client: mockAPIClient)
    }

    private func getLocationsListPresenter(fromJsonFile file: String) -> LocationsListPresenter {
        let mockSession = URLSessionMock.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        let localLocationRepository = UserDefaultLocalLocationRepository(userDefaults: userDefaults)
        let presenter = LocationsListPresenter(locationsRepository: repository,
                                      localLocationRepository: localLocationRepository)
        presenter.output = mockLocationsListPresenterOutput
        return presenter
    }
}

final class MockLocationsListPresenterOutput: UIViewController, LocationsListPresenterOutput {
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {

    }

    var tableSections: [TableViewSectionType] = []
    var error: Error!

    func updateData(error: Error) {
        self.error = error
    }

    func updateData(tableSections: [TableViewSectionType]) {
        self.tableSections = tableSections
    }
}
