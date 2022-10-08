//
//  NetworkMock.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import UIKit

class URLSessionMock: URLSessionProtocol {
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.

    var completionHandler: (data: Data?, response: URLResponse?, error: Error?)

    init(completionHandler: (Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }

    func data(with url: URL) async throws -> (Data, URLResponse) {
        let data = completionHandler.data
        let response = completionHandler.response
        if let error = completionHandler.error {
            throw error
        }
        if let data, let response {
            return (data, response)
        }
        throw LocationsListError.runtimeError("Missed Data")
    }

    static func createMockSession(fromJsonFile file: String,
                                  andStatusCode code: Int,
                                  andError error: Error?) -> URLSessionMock {

        let data = DataLoader().loadJsonData(file: file)
        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return URLSessionMock(completionHandler: (data, response, error))
    }
}
