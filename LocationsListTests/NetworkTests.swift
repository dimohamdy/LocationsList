//
//  NetworkTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import XCTest

// final class NetworkTests: XCTestCase {
//    
//    func test_GetItems_Success() throws {
//
//        let mockAPIClient =  getMockAPIClient(fromJsonFile: "data")
//        loadData(mockAPIClient: mockAPIClient) { (result: Result<FlickrLocation, LocationsListError>) in
//            switch result {
//            case .success(let data):
//                guard let locations = data.locations else {
//                    XCTFail("Can't get Data")
//                    return
//                }
//                XCTAssertGreaterThan(locations.locations.count, 0)
//            default:
//                XCTFail("Can't get Data")
//            }
//        }
//    }
//
//    func test_NotGetData_Fail() throws {
//
//        let mockAPIClient =  getMockAPIClient(fromJsonFile: "noData")
//        loadData(mockAPIClient: mockAPIClient) { (result: Result<FlickrLocation, LocationsListError>) in
//            switch result {
//            case .success(let data):
//                guard let locations = data.locations?.locations else {
//                    XCTFail("Can't get Data")
//                    return
//                }
//                XCTAssertEqual(locations.count, 0)
//            default:
//                XCTFail("Can't get Data")
//            }
//        }
//    }
//
//    private func getMockAPIClient(fromJsonFile file: String) -> APIClient {
//        let mockSession = URLSessionMock.createMockSession(fromJsonFile: file, andStatusCode: 200, andError: nil)
//        return APIClient(withSession: mockSession)
//    }
//
//    private func loadData<T: Decodable>(mockAPIClient: APIClient, completion: @escaping (Result<T, LocationsListError>) -> Void) {
//        guard let path = APILinksFactory.API.locations.path,
//              let url = URL(string: path) else {
//            return
//        }
//        mockAPIClient.loadData(from: url, completion: completion)
//    }
//    
// }
