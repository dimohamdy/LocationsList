//
//  AddLocationViewControllerTests.swift
//  LocationsListTests
//
//  Created by Dimo Abdelaziz on 06/10/2022.
//

import Foundation
import SnapshotTesting
@testable import LocationsList
import XCTest

final class AddLocationViewControllerTests: XCTestCase {
    var addLocationViewController: AddLocationViewController!
    var navigationController: UINavigationController!

    var localLocationRepository: UserDefaultLocalLocationRepository!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        localLocationRepository = UserDefaultLocalLocationRepository(userDefaults: userDefaults)
    }

    override func tearDown() {
        addLocationViewController = nil
        _ = localLocationRepository.clearLocations()
    }

    func test_snapshot_fill_addLocation_form() {
        let expectation = XCTestExpectation()
        setVC(localLocationRepository: localLocationRepository)

        if let locationNameTextField = getTextField(tag: AddLocationViewController.Tags.locationNameTextField) {
            locationNameTextField.text = "Cairo"
        }

        if let latitudeTextField = getTextField(tag: AddLocationViewController.Tags.latitudeTextField) {
            latitudeTextField.text = "12.3333"

        }

        if let longitudeTextField = getTextField(tag: AddLocationViewController.Tags.longitudeTextField) {
            longitudeTextField.text = "34.44444"
        }

        assertSnapshot(matching: navigationController, as: .image)
    }

    func test_snapshot_fill_addLocation_form_error() {
        let expectation = XCTestExpectation()
        setVC(localLocationRepository: localLocationRepository)

        if let locationNameTextField = getTextField(tag: AddLocationViewController.Tags.locationNameTextField) {
            locationNameTextField.text = "Cairo"
        }

        if let latitudeTextField = getTextField(tag: AddLocationViewController.Tags.latitudeTextField) {
            latitudeTextField.text = "123333"

        }

        if let longitudeTextField = getTextField(tag: AddLocationViewController.Tags.longitudeTextField) {
            longitudeTextField.text = "3444444"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in

            assertSnapshot(matching: navigationController, as: .image)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 6)
    }



//    func test_snapshot_getData_online() {
//        let expectation = XCTestExpectation()
//
//        let presenter = AddLocationPresenter(localLocationRepository: localLocationRepository)
//        setVC(presenter: presenter)
//        presenter.getLocation()
//
//        // Check the datasource after getLocations result bind to TableView
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
//            assertSnapshot(matching: addLocationViewController, as: .image)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 3)
//
//    }
}

extension AddLocationViewControllerTests {

    func getTextField(tag: AddLocationViewController.Tags) -> UITextField? {
        return addLocationViewController.view.viewWithTag(tag.rawValue) as? UITextField
    }

    func getSaveButtonItem() -> UIBarButtonItem? {
        return addLocationViewController.navigationItem.rightBarButtonItems?.first
    }

    func setVC(localLocationRepository: LocalLocationRepository) {
        addLocationViewController = AddLocationBuilder.viewController(localLocationRepository: localLocationRepository)
        navigationController = UINavigationController(rootViewController: addLocationViewController)
    }
}
