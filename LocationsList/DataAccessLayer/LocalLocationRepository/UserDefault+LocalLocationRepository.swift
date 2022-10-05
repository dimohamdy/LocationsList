//
//  UserDefault+LocalLocationRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

final class UserDefaultLocalLocationRepository: LocalLocationRepository {

    private var locations: [Location] = []

    static let shared = UserDefaultLocalLocationRepository()
    
    private init() {
        locations = getLocations()
    }
    
    func clearLocations() -> [String] {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.Locations.rawValue)
        return []
    }

    func save(location: Location) {
        locations.append(location)
        save()
    }

    func remove(location: Location) {
        locations.removeAll(where: {
            $0.name == location.name
        })
    }

    func getLocations() -> [Location] {
        load()
        return locations
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey:  UserDefaultsKey.Locations.rawValue),
              let savedLocations = try? JSONDecoder().decode([Location].self, from: data) else { locations = []; return }
        locations = savedLocations
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            UserDefaults.standard.set(data, forKey:  UserDefaultsKey.Locations.rawValue)
        } catch {
            print(error)
        }
    }
}

enum UserDefaultsKey: String {
    case Locations
}
