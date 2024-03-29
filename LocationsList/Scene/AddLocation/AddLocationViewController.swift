//
//  AddLocationViewController.swift
//  AddLocation
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit
extension AddLocationViewController {
    enum Tags: Int {
    case locationNameTextField = 1
    case latitudeTextField
    case longitudeTextField
        
    case saveButtonItem
    case cancelButtonItem
    }
}

final class AddLocationViewController: UIViewController {

    // MARK: Outlets

    private let locationNameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Amsterdam"
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            textField.becomeFirstResponder()
        }
        textField.tag = AddLocationViewController.Tags.locationNameTextField.rawValue
        return textField
    }()

    private let latitudeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "47.4343434"
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = AddLocationViewController.Tags.latitudeTextField.rawValue
        return textField
    }()

    private let longitudeTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "32.4343434"
        textField.keyboardType = .decimalPad
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = AddLocationViewController.Tags.longitudeTextField.rawValue
        return textField
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()


    private let presenter: AddLocationPresenterInput

    // MARK: View lifeCycle

    init(presenter: AddLocationPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
    }

    // MARK: - Setup UI
    private func setupUI() {

        [locationNameTextField, latitudeTextField, longitudeTextField].forEach {
            $0.delegate = self
            stackView.addArrangedSubview($0)
        }

        view.addSubview((stackView))

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    private func configureNavigationBar() {
        navigationItem.title = Strings.addLocationTitle.localized()
        navigationController?.hidesBarsOnSwipe = true

        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTodoItem))

        saveButtonItem.tintColor = .label
        cancelButtonItem.tintColor = .label
        saveButtonItem.tag = Tags.saveButtonItem.rawValue
        cancelButtonItem.tag = Tags.cancelButtonItem.rawValue

        navigationItem.rightBarButtonItems = [saveButtonItem]
        navigationItem.leftBarButtonItem = cancelButtonItem
    }

    @objc
    private func saveLocation() {
        var locationValue: String?
        var latitudeValue: Double?
        var longitudeValue: Double?

        if let locationName = locationNameTextField.text, !locationName.isEmpty {
            locationValue = locationName
        }

        // Validate latitude value
        if let latitude = Double(latitudeTextField.text ?? ""), presenter.validate(latitude: latitude) {
            latitudeValue = latitude
        } else {
            showError(title: Strings.wrongData.localized(), subtitle: Strings.checkValueLatitude.localized())
        }

        // Validate longitude value
        if let longitude = Double(longitudeTextField.text ?? ""), presenter.validate(longitude: longitude) {
            longitudeValue = longitude
        } else {
            showError(title: Strings.wrongData.localized(), subtitle: Strings.checkValueLongitude.localized())
        }

        if let locationValue, let latitudeValue, let longitudeValue {
            presenter.add(location: Location(name: locationValue, lat: latitudeValue, long: longitudeValue))
        }
    }

    @objc
    func cancelTodoItem(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - AddLocationPresenterOutput
extension AddLocationViewController: AddLocationPresenterOutput {
    func addLocation(success: Bool) {
        if success {
            showSuccess(title: Strings.locationAdded.localized(), subtitle: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }

}

extension AddLocationViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case locationNameTextField:
            latitudeTextField.becomeFirstResponder()
        case latitudeTextField:
            longitudeTextField.becomeFirstResponder()
        default:
            break
        }

        return true
    }
}
