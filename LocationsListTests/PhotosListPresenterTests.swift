//
//  LocationsListPresenterTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import XCTest
@testable import LocationsList

final class LocationsListPresenterTests: XCTestCase {
    var mockLocationsListPresenterOutput: MockLocationsListPresenterOutput!

    override func setUp() {
        mockLocationsListPresenterOutput = MockLocationsListPresenterOutput()
    }

    override func tearDown() {
        mockLocationsListPresenterOutput = nil
        Reachability.shared =  MockReachability(internetConnectionState: .satisfied)
    }

    func test_getLocations_success() {
        let expectation = XCTestExpectation()

        let presenter = getLocationsListPresenter(fromJsonFile: "data")
        presenter.getLocation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            XCTAssertEqual(mockLocationsListPresenterOutput.itemsForTable.count, 1)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func test_getLocations_noResult() {
        let expectation = XCTestExpectation()

        let presenter = getLocationsListPresenter(fromJsonFile: "noData")
        presenter.getLocation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            XCTAssertEqual(mockLocationsListPresenterOutput.itemsForTable.count, 0)
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
        Reachability.shared =  MockReachability(internetConnectionState: .unsatisfied)
        let presenter = getLocationsListPresenter(fromJsonFile: "noData")
        presenter.getLocation()
        XCTAssertEqual(mockLocationsListPresenterOutput.itemsForTable.count, 0)
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
        let mockAPIClient =  APIClient(withSession: mockSession)
        return WebLocationsRepository(client: mockAPIClient)
    }

    private func getLocationsListPresenter(fromJsonFile file: String) -> LocationsListPresenter {
        let mockSession = URLSessionMock.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
        let repository = getMockWebLocationsRepository(mockSession: mockSession)
        return LocationsListPresenter(output: mockLocationsListPresenterOutput, locationsRepository: repository)
    }
}

final class MockLocationsListPresenterOutput: UIViewController, LocationsListPresenterOutput {
    func clearCollection() {

    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {

    }

    var itemsForTable: [ItemTableViewCellType] = []
    var error: Error!

    func updateData(error: Error) {
        self.error = error
    }

    func updateData(itemsForTable: [ItemTableViewCellType]) {
        self.itemsForTable = itemsForTable
    }
}