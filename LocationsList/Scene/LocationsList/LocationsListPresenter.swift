//
//  LocationsListPresenter.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation
import UIKit

protocol LocationsListPresenterInput: BasePresenterInput {
    func open(indexPath: IndexPath)
    func getLocation()
}

protocol LocationsListPresenterOutput: BasePresenterOutput {
    func updateData(error: Error)
    func updateData(tableSections: [TableViewSectionType])
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType)
}

final class LocationsListPresenter {

    // MARK: Injections
    weak var output: LocationsListPresenterOutput?
    let locationsRepository: WebLocationsRepository
    var localLocationRepository: LocalLocationRepository
    let reachable: Reachable

    // internal

    private var onlineLocations: [Location] = []
    private var localLocations: [Location] = []

    // MARK: Init
    init(locationsRepository: WebLocationsRepository = WebLocationsRepository(),
         localLocationRepository: LocalLocationRepository = UserDefaultLocalLocationRepository.shared,
         reachable: Reachable = Reachability.shared) {

        self.locationsRepository = locationsRepository
        self.localLocationRepository = localLocationRepository
        self.reachable = reachable

        self.localLocationRepository.delegate = self

        [Notifications.Reachability.connected.name, Notifications.Reachability.notConnected.name].forEach { notification in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }

    }
}

// MARK: - LocationsListPresenterInput
extension LocationsListPresenter: LocationsListPresenterInput {

    func open(indexPath: IndexPath) {
        let location = indexPath.section == 0 ? onlineLocations[indexPath.row] : localLocations[indexPath.row]
        if let wikipediaURL = URL(string: "wikipedia://location?latitude=\(location.lat)&longitude=\(location.long)") {
            UIApplication.shared.open(wikipediaURL)
        }
    }

    func getLocation() {
        guard reachable.isConnected else {
            output?.updateData(error: LocationsListError.noInternetConnection)
            return
        }

        output?.showLoading()
        Task {
            do {
                onlineLocations = try await locationsRepository.getLocations()
                localLocations = try await localLocationRepository.getLocations()

                let locationsSections = prepareData(onlineLocations: onlineLocations, localLocations: localLocations)
                DispatchQueue.main.async { [self] in

                    output?.hideLoading()

                    if locationsSections.isEmpty {
                        output?.updateData(error: LocationsListError.noResults)
                    } else {
                        output?.updateData(tableSections: locationsSections)
                    }
                }
            } catch let error {
                DispatchQueue.main.async { [self] in
                    output?.updateData(error: error)
                }
            }
        }
    }

    @objc
    private func changeInternetConnection(notification: Notification) {
        if notification.name == Notifications.Reachability.notConnected.name {
            DispatchQueue.main.async { [self] in
                output?.showError(title: Strings.noInternetConnectionTitle.localized(), subtitle: Strings.noInternetConnectionSubtitle.localized())
                output?.updateData(error: LocationsListError.noInternetConnection)
            }
        }
    }

    func prepareData(onlineLocations: [Location], localLocations: [Location]) -> [TableViewSectionType] {
        var locationsSections: [TableViewSectionType] = [TableViewSectionType]()
        if !onlineLocations.isEmpty {
            locationsSections.append(TableViewSectionType.online(locations: onlineLocations.map({ $0.locationModel })))
        }
        if !localLocations.isEmpty {
            locationsSections.append(TableViewSectionType.local(locations: localLocations.map({ $0.locationModel })))
        }
        return locationsSections
    }
}

extension LocationsListPresenter: LocalLocationRepositoryUpdate {
    func updated(localLocations: [Location]) {
        let locationsSections = prepareData(onlineLocations: onlineLocations, localLocations: localLocations)
        DispatchQueue.main.async { [self] in
            output?.updateData(tableSections: locationsSections)
        }
    }
}
