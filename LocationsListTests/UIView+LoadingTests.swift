//
//  UIViewLoadingTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

@testable import LocationsList
import XCTest

final class UIViewLoadingTests: XCTestCase {
    var view: UIView!

    override func setUp() {
        view = UIView()
    }

    override func tearDown() {
        view = nil
    }

    func test_showLoading() {
        view.showLoadingIndicator()
        XCTAssertNotNil(view.viewWithTag(999999) )
        if let activityIndicatorView = view.viewWithTag(999999) as? UIActivityIndicatorView {
            XCTAssertTrue(activityIndicatorView.isAnimating)
            XCTAssertFalse(activityIndicatorView.isHidden)
        }
    }

    func test_dismissLoading() {
        view.dismissLoadingIndicator()
        XCTAssertNil(view.viewWithTag(999999) )
    }

}
