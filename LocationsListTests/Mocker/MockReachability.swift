//
//  MockReachability.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Network
import Foundation
@testable import LocationsList

final class MockReachability: Reachability {

    let internetConnectionState: NWPath.Status

    override var isConnected: Bool {
        return internetConnectionState == .satisfied
    }

    init(internetConnectionState: NWPath.Status) {
        self.internetConnectionState  = internetConnectionState
        super.init()
    }
}
