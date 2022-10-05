//
//  LocationsListError.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

enum LocationsListError: Error {
    case failedConnection
    case wrongURL
    case noResults
    case noInternetConnection
    case runtimeError(String)
    case parseError
    case fileNotFound
    case invalidServerResponse
    
    var localizedDescription: String {
        switch self {
        case .noResults:
            return Strings.noLocationsErrorTitle.localized()
        case .noInternetConnection:
            return Strings.noInternetConnectionTitle.localized()
        default:
            return Strings.commonGeneralError.localized()
        }
    }
}
