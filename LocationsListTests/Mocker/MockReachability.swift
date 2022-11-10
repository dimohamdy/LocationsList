//
//  MockReachability.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
@testable import LocationsList
import Network

final class MockReachability: Reachable {

    let internetConnectionState: NWPath.Status

    var isConnected: Bool {
        internetConnectionState == .satisfied
    }

    init(internetConnectionState: NWPath.Status) {
        self.internetConnectionState = internetConnectionState
    }

    func startNetworkReachabilityObserver() {

    }
}
