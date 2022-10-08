//
//  Strings.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation

enum Strings: String {

    // MARK: Errors
    case commonGeneralError = "Common_GeneralError"
    case commonInternetError = "Common_InternetError"

    // MARK: Location
    case locationListTitle = "Location_List_Title"
    case addLocationTitle = "Add_Location_Title"

    // MARK: Internet Errors
    case noInternetConnectionTitle = "No_Internet_Connection_Title"
    case noInternetConnectionSubtitle = "No_Internet_Connection_Subtitle"

    // MARK: Locations Errors
    case noLocationsErrorTitle = "No_Locations_Error_Title"
    case noLocationsErrorSubtitle = "No_Locations_Error_Subtitle"


    // MARK: Collection Headers
    case onlineTitle = "Online_Title"
    case localTitle = "Local_Title"

    case tryAction = "Try_Action"

    case latitude = "Latitude"
    case longitude = "Longitude"

    case wrongData = "Wrong_Data"

    case checkValueLatitude = "Check_Value_Latitude"

    case checkValueLongitude = "Check_Value_Longitude"

    case locationAdded = "Location_Added_Successfully"

    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
