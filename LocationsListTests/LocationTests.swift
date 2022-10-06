//
//  LocationTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import XCTest
@testable import LocationsList

final class LocationTests: XCTestCase {

    private let location = Data("""
        {
          "name": "Amsterdam",
          "lat": 52.3547498,
          "long": 4.8339215
        }
    """.utf8)

    func testDecoding_whenMissingRequiredKeys_itThrows() throws {
        try ["lat", "long"].forEach { key in
            AssertThrowsKeyNotFound(key, decoding: Location.self, from: try location.json(deletingKeyPaths: key))
        }
    }

    func testDecoding_whenLocationData_returnsALocationObject() throws {
       let location =  try JSONDecoder().decode(Location.self, from: location)
        XCTAssertEqual(location.name, "Amsterdam")
        XCTAssertEqual(location.lat, 52.3547498)
        XCTAssertEqual(location.long, 4.8339215)
    }

    func AssertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data), file: file, line: line) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.", file: file, line: line)
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)", file: file, line: line)
            }
        }
    }
}

extension Data {
    func json(deletingKeyPaths keyPaths: String...) throws -> Data {
        let decoded = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject

        for keyPath in keyPaths {
            decoded.setValue(nil, forKeyPath: keyPath)
        }

        return try JSONSerialization.data(withJSONObject: decoded)
    }
}
