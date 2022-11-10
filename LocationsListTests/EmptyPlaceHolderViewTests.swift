//
//  EmptyPlaceHolderViewTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import XCTest

final class EmptyPlaceHolderViewTests: XCTestCase {

    var emptyPlaceHolderView: EmptyPlaceHolderView!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        emptyPlaceHolderView = EmptyPlaceHolderView()
    }

    override func tearDown() {
        emptyPlaceHolderView = nil
    }

    func test_NoInternetConnection_State() {
        emptyPlaceHolderView.emptyPlaceHolderType = .noInternetConnection
        if let button = emptyPlaceHolderView.viewWithTag(1) as? UIButton {
            XCTAssertEqual(button.titleLabel?.text, Strings.tryAction.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(2) as? UILabel {
            XCTAssertEqual(label.text, Strings.noInternetConnectionTitle.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(3) as? UILabel {
            XCTAssertEqual(label.text, Strings.noInternetConnectionSubtitle.localized())
        }
    }

    func test_NoResults_State() {
        emptyPlaceHolderView.emptyPlaceHolderType = .noResults
        if let button = emptyPlaceHolderView.viewWithTag(1) as? UIButton {
            XCTAssertEqual(button.titleLabel?.text, Strings.tryAction.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(2) as? UILabel {
            XCTAssertEqual(label.text, Strings.noLocationsErrorTitle.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(3) as? UILabel {
            XCTAssertEqual(label.text, Strings.noLocationsErrorSubtitle.localized())
        }
    }

    func test_CustomError_State() {
        let message = "Some thing happen"
        emptyPlaceHolderView.emptyPlaceHolderType = .error(message: message)
        if let button = emptyPlaceHolderView.viewWithTag(1) as? UIButton {
            XCTAssertEqual(button.titleLabel?.text, Strings.tryAction.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(2) as? UILabel {
            XCTAssertEqual(label.text, Strings.commonGeneralError.localized())
        }

        if let label = emptyPlaceHolderView.viewWithTag(3) as? UILabel {
            XCTAssertEqual(label.text, message)
        }
    }

}
