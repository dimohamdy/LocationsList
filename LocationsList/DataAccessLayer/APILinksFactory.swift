//
//  APILinksFactory.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

struct APILinksFactory {
    
    private static let baseURL = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/"
    
    enum API {
        case locations

        var path: String? {
            switch self {
            case .locations:
                return APILinksFactory.baseURL + "locations.json"
            }
        }
    }
}
