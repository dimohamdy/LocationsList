//
//  WebLocationsRepositoryTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import XCTest

final class WebLocationsRepositoryTests: XCTestCase {
    var webLocationsRepository: WebLocationsRepository!
    
    override func tearDown() {
        webLocationsRepository = nil
    }
    
    func test_GetItems_FromAPI() throws {
        runAsyncTest {
            let mockSession = URLSessionMock.createMockSession(fromJsonFile: "data", andStatusCode: 200, andError: nil)
            let mockAPIClient = APIClient(withSession: mockSession)
            self.webLocationsRepository = WebLocationsRepository(client: mockAPIClient)
            // Act: get data from API .
            let locations = try await self.webLocationsRepository.getLocations()
            // Assert: Verify it's have a data.
            XCTAssertGreaterThan(locations.count, 0)
            XCTAssertEqual(locations.count, 4)
        }
    }

    func test_NoResult_FromAPI() {
        runAsyncTest { [self] in
            let mockSession = URLSessionMock.createMockSession(fromJsonFile: "noData", andStatusCode: 200, andError: nil)
            let mockAPIClient = APIClient(withSession: mockSession)
            webLocationsRepository = WebLocationsRepository(client: mockAPIClient)
            // Act: get data from API .
            let locations = try await webLocationsRepository.getLocations()
            XCTAssertEqual(locations.count, 0)
        }
    }
}

extension XCTestCase {
    func runAsyncTest(
        named testName: String = #function,
        in file: StaticString = #file,
        at line: UInt = #line,
        withTimeout timeout: TimeInterval = 10,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        if let error = thrownError {
            XCTFail(
                "Async error thrown: \(error)",
                file: file,
                line: line
            )
        }
    }
}
