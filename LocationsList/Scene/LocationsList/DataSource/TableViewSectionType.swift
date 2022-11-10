//
//  TableViewSectionType.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

enum TableViewSectionType {
    case online(locations: [UILocationModel])
    case local(locations: [UILocationModel])
}
