//
//  AddLocationViewController.swift
//  AddLocation
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

final class AddLocationViewController: UIViewController {

    private let locationNameTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Amsterdam"
        textField.keyboardType = .default
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing;

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            textField.becomeFirstResponder()
        }
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
        textField.clearButtonMode = .whileEditing;
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
        textField.clearButtonMode = .whileEditing;

        return textField
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()

    // MARK: Outlets

    var presenter: AddLocationPresenterInput?
    
    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
//        view.addSubview(locationNameTextField)
//        NSLayoutConstraint.activate([
//            locationNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            locationNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
//            locationNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            locationNameTextField.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        view.backgroundColor = .systemBackground

        [locationNameTextField, latitudeTextField, longitudeTextField].forEach {
            $0.delegate = self
            stackView.addArrangedSubview($0)
        }
//        scrollView.addSubview(stackView)
        view.addSubview((stackView))

        view.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
        ])

//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            stackView.heightAnchor.constraint(equalToConstant: 200),
////            stackView.widthAnchor.constraint(equalToConstant: 300)
//
//        ])




        scrollView.backgroundColor = .blue
    }

    private func configureNavigationBar() {
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
//        navigationItem.title = Strings.locationTitle.localized()
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = UIColor.systemBackground
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
//        appearance.shadowColor = .clear
//        appearance.shadowImage = UIImage()
//
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.hidesBarsOnSwipe = true

        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLocation))
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTodoItem))

        saveButtonItem.tintColor = .label
        cancelButtonItem.tintColor = .label

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

        if let latitude = Double(latitudeTextField.text ?? "") {
            latitudeValue = latitude
        }

        if let longitude = Double(longitudeTextField.text ?? "") {
            longitudeValue = longitude
        }

        if let locationValue ,let latitudeValue, let longitudeValue {
            presenter?.add(location: Location(name: locationValue, lat: latitudeValue, long: longitudeValue))
        }
    }

    @objc func cancelTodoItem(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - AddLocationPresenterOutput
extension AddLocationViewController: AddLocationPresenterOutput {
    func addLocation(success: Bool) {
        if success {
            navigationController?.popViewController(animated: true)
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
        case longitudeTextField:
            break
            // Validate Text Field
            //            let (valid, message) = validate(textField)
            //
            //            if valid {
            //                emailTextField.becomeFirstResponder()
            //            }
            //
            //            // Update Password Validation Label
            //            self.passwordValidationLabel.text = message
            //
            //            // Show/Hide Password Validation Label
            //            UIView.animate(withDuration: 0.25, animations: {
            //                self.passwordValidationLabel.isHidden = valid
            //            })
        default:
            locationNameTextField.resignFirstResponder()
        }

        return true
    }
}
