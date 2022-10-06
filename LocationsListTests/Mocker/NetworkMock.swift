//
//  NetworkMock.swift
//  LocationsListTests
//
//  Copyright © 2021 BinaryBoy. All rights reserved.
//

import UIKit
@testable import LocationsList

//
//protocol URLSessionProtocol {
//    func data(with url: URL) async throws -> (Data, URLResponse)
//}

class URLSessionMock: URLSessionProtocol {
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.

    var completionHandler: (data:Data?, response: URLResponse?, error: Error?)

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



/*
class URLSessionMock: URLSession {

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void



    override func data(from url: URL) async throws -> (Data, URLResponse) {
        let data = self.data
        let response = self.response
        if let error = self.error {
            throw error
        }
        if let data, let response {
            return (data, response)
        }
    }

    static func createMockSession(fromJsonFile file: String,
                                  andStatusCode code: Int,
                                  andError error: Error?) -> URLSessionMock {

        let data = DataLoader().loadJsonData(file: file)

        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return URLSessionMock(completionHandler: (data, response, error))
    }
}

final class URLSessionMockDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}

final class URLSessionMock: URLSessionProtocol {
    var dataTask = URLSessionMockDataTask()

    var completionHandler: (Data?, URLResponse?, Error?)

    init(completionHandler: (Data?, URLResponse?, Error?)) {
        self.completionHandler = completionHandler
    }

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(self.completionHandler.0,
                          self.completionHandler.1,
                          self.completionHandler.2)

        return dataTask
    }

    static func createMockSession(fromJsonFile file: String,
                                  andStatusCode code: Int,
                                  andError error: Error?) -> URLSessionMock {

        let data = DataLoader().loadJsonData(file: file)

        let response = HTTPURLResponse(url: URL(string: "TestUrl")!, statusCode: code, httpVersion: nil, headerFields: nil)

        return URLSessionMock(completionHandler: (data, response, error))
    }
}
*/
