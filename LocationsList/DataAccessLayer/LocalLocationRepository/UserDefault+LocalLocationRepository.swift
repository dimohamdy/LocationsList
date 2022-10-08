//
//  UserDefault+LocalLocationRepository.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

final class UserDefaultLocalLocationRepository: LocalLocationRepository {

    weak var delegate: LocalLocationRepositoryUpdate?

    private var locations: [Location] = [] {
        didSet {
            delegate?.updated(localLocations: locations)
        }
    }

    static let shared = UserDefaultLocalLocationRepository()
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        locations = getLocations()
    }
    
    func clearLocations() -> [String] {
        userDefaults.removeObject(forKey: UserDefaultsKey.locations.rawValue)
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
        guard let data = userDefaults.data(forKey:  UserDefaultsKey.locations.rawValue),
              let savedLocations = try? JSONDecoder().decode([Location].self, from: data) else { locations = []; return }
        locations = savedLocations
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(locations)
            userDefaults.set(data, forKey:  UserDefaultsKey.locations.rawValue)
        } catch {
            print(error)
        }
    }
}
