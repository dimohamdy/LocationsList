//
//  LocationsListViewController.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

final class LocationsListViewController: UIViewController {

    private var tableDataSource: LocationsTableViewDataSource?

    // MARK: Outlets
    private let locationsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.showsHorizontalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.register(GeneralTableHeader.self, forHeaderFooterViewReuseIdentifier: GeneralTableHeader.identifier)
        tableView.tag = 1
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .clear
        return tableView
    }()

    private let presenter: LocationsListPresenterInput
    private let router: LocationsListRouter

    init(presenter: LocationsListPresenterInput, router: LocationsListRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        presenter.getLocation()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(locationsTableView)
        NSLayoutConstraint.activate([
            locationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            locationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        navigationItem.title = Strings.locationListTitle.localized()
        navigationController?.hidesBarsOnSwipe = true

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))

        addButtonItem.tintColor = .label
        refreshButtonItem.tintColor = .label

        navigationItem.rightBarButtonItems = [addButtonItem]
        navigationItem.leftBarButtonItem = refreshButtonItem
    }

    @objc
    private func addLocation() {
        router.navigateToAddLocation()
    }

    @objc
    private func refresh() {
        presenter.getLocation()
    }
}

// MARK: - LocationsListPresenterOutput
extension LocationsListViewController: LocationsListPresenterOutput {

    private func clearTableView() {
        tableDataSource = nil
        locationsTableView.dataSource = nil
        locationsTableView.dataSource = nil
        locationsTableView.reloadData()
    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {
        clearTableView()
        locationsTableView.setEmptyView(emptyPlaceHolderType: emptyPlaceHolderType, completionBlock: { [weak self] in
            self?.presenter.getLocation()
        })
    }

    func updateData(error: Error) {
        switch error as? LocationsListError {
        case .noResults:
            emptyState(emptyPlaceHolderType: .noResults)
        case .noInternetConnection:
            emptyState(emptyPlaceHolderType: .noInternetConnection)
        default:
            emptyState(emptyPlaceHolderType: .error(message: error.localizedDescription))
        }
    }

    // Update sections not the whole table
    func updateData(tableSections: [TableViewSectionType]) {
        // Clear any placeholder view from tableView
        locationsTableView.restore()

        // Reload the tableView
        tableDataSource = LocationsTableViewDataSource(presenterInput: presenter, tableSections: tableSections)
        locationsTableView.dataSource = tableDataSource
        locationsTableView.delegate = tableDataSource
        locationsTableView.reloadData()
    }
}
