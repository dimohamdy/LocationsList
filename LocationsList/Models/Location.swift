//
//  Location.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

struct LocationsResult: Codable {
    let locations: [Location]
}


struct Location: Codable, Equatable {

    let name: String
    let lat: Double
    let long: Double

    private enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decode(Double.self, forKey: .lat)
        long = try values.decode(Double.self, forKey: .long)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? "lat:\(lat), long:\(long)"
    }

    init(name: String,lat: Double, long: Double) {
        self.lat = lat
        self.long = long
        self.name = name
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.name == rhs.name
    }
}
