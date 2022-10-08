//
//  LocationsListPresenter.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation
import UIKit

protocol LocationsListPresenterInput: BasePresenterInput {
    func open(location: Location)
    func getLocation()
}

protocol LocationsListPresenterOutput: BasePresenterOutput {
    func updateData(error: Error)
    func updateData(tableSections: [TableViewSectionType])
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType)
}

final class LocationsListPresenter {

    // MARK: Injections
    private weak var output: LocationsListPresenterOutput?
    let locationsRepository: WebLocationsRepository
    var localLocationRepository: LocalLocationRepository

    // internal

    private var onlineLocations: [Location] = []
    private var localLocations: [Location] = []

    // MARK: Init
    init(output: LocationsListPresenterOutput,
         locationsRepository: WebLocationsRepository = WebLocationsRepository(),
         localLocationRepository: LocalLocationRepository = UserDefaultLocalLocationRepository.shared) {

        self.output = output
        self.locationsRepository = locationsRepository
        self.localLocationRepository = localLocationRepository

        self.localLocationRepository.delegate = self

        [Notifications.Reachability.connected.name, Notifications.Reachability.notConnected.name].forEach { notification in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }

    }
}

// MARK: - LocationsListPresenterInput
extension LocationsListPresenter: LocationsListPresenterInput {

    func open(location: Location) {
        let location = "wikipedia://location?latitude=\(location.lat)&longitude=\(location.long)"

        if let wikipediaURL = URL(string: location) {
            UIApplication.shared.open(wikipediaURL)
        }
    }

    func getLocation() {
        guard Reachability.shared.isConnected else {
            self.output?.updateData(error: LocationsListError.noInternetConnection)
            return
        }

        output?.showLoading()
        Task {
            do {
                onlineLocations = try await locationsRepository.getLocations()
                localLocations = try await localLocationRepository.getLocations()

                let locationsSections = prepareData(onlineLocations: onlineLocations, localLocations: localLocations)
                output?.hideLoading()

                if locationsSections.isEmpty {
                    output?.updateData(error: LocationsListError.noResults)
                } else {
                    output?.updateData(tableSections: locationsSections)
                }

            } catch let error {
                output?.updateData(error: error)
            }
        }
    }

    @objc
    private func changeInternetConnection(notification: Notification) {
        if notification.name == Notifications.Reachability.notConnected.name {
            output?.showError(title: Strings.noInternetConnectionTitle.localized(), subtitle: Strings.noInternetConnectionSubtitle.localized())
            output?.updateData(error: LocationsListError.noInternetConnection)
        }
    }

    func prepareData(onlineLocations: [Location], localLocations: [Location]) -> [TableViewSectionType] {
        var locationsSections: [TableViewSectionType] = [TableViewSectionType]()
        if !onlineLocations.isEmpty {
            locationsSections.append(TableViewSectionType.online(locations: onlineLocations))
        }
        if !localLocations.isEmpty {
            locationsSections.append(TableViewSectionType.local(locations: localLocations))
        }
        return locationsSections
    }
}

extension LocationsListPresenter: LocalLocationRepositoryUpdate {
    func updated(localLocations: [Location]) {
        let locationsSections = prepareData(onlineLocations: onlineLocations, localLocations: localLocations)
        output?.updateData(tableSections: locationsSections)
    }
}
