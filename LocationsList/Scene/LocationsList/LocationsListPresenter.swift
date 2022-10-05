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
    func updateData(itemsForTable: [ItemTableViewCellType])
    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType)
}

final class LocationsListPresenter {

    // MARK: Injections
    private weak var output: LocationsListPresenterOutput?
    let locationsRepository: WebLocationsRepository
    let localLocationRepository: LocalLocationRepository

    // internal
    private var locationsSections: [ItemTableViewCellType] = [ItemTableViewCellType]()

    // MARK: Init
    init(output: LocationsListPresenterOutput,
         locationsRepository: WebLocationsRepository = WebLocationsRepository(),
         localLocationRepository: LocalLocationRepository = UserDefaultLocalLocationRepository.shared) {

        self.output = output
        self.locationsRepository = locationsRepository
        self.localLocationRepository = localLocationRepository
        
        [Notifications.Reachability.connected.name, Notifications.Reachability.notConnected.name].forEach { (notification) in
            NotificationCenter.default.addObserver(self, selector: #selector(changeInternetConnection), name: notification, object: nil)
        }
    }
}

// MARK: - LocationsListPresenterInput
extension LocationsListPresenter: LocationsListPresenterInput {

    func open(location: Location) {
        let location = "wikipedia://location?latitude=\(location.lat)&longitude=\(location.long)"

        if let wikipediaURL = URL(string: location), UIApplication.shared.canOpenURL(wikipediaURL) {
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
            locationsSections = []
            do {
                let onlineLocations = try await locationsRepository.getLocations()
                if !onlineLocations.isEmpty {
                    let temp1 = ItemTableViewCellType.online(locations: onlineLocations)
                    locationsSections.append(temp1)
                }

                let localLocations = try await localLocationRepository.getLocations()
                if !localLocations.isEmpty {
                    let temp2 = ItemTableViewCellType.online(locations: localLocations)
                    locationsSections.append(temp2)
                }
                output?.hideLoading()


                if locationsSections.isEmpty {
                    output?.updateData(error: LocationsListError.noResults)
                } else {
                    output?.updateData(itemsForTable: locationsSections)
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

}
