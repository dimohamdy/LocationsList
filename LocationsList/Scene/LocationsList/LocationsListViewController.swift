//
//  LocationsListViewController.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

final class LocationsListViewController: UIViewController {

    private(set) var tableDataSource: LocationsTableViewDataSource?

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

    var presenter: LocationsListPresenterInput?
    let router: LocationsListRouter!

    init(withPresenter presenter: LocationsListPresenterInput? = nil, router: LocationsListRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        self.presenter = nil
        self.router = nil
        super.init(coder: aDecoder)
    }

    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        presenter?.getLocation()
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
        navigationItem.title = Strings.locationTitle.localized()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        presenter?.getLocation()
    }
}

// MARK: - LocationsListPresenterOutput
extension LocationsListViewController: LocationsListPresenterOutput {

    func clearCollection() {
        DispatchQueue.main.async {
            self.tableDataSource = nil
            self.locationsTableView.dataSource = nil
            self.locationsTableView.dataSource = nil
            self.locationsTableView.reloadData()
        }
    }

    func emptyState(emptyPlaceHolderType: EmptyPlaceHolderType) {
        clearCollection()
        locationsTableView.setEmptyView(emptyPlaceHolderType: emptyPlaceHolderType, completionBlock: { [weak self] in
            // hello world
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

    func updateData(itemsForTable: [ItemTableViewCellType]) {
        DispatchQueue.main.async {
            //Clear any placeholder view from tableView
            self.locationsTableView.restore()

            // Reload the tableView
            self.tableDataSource = LocationsTableViewDataSource(presenterInput: self.presenter, itemsForTable: itemsForTable)
            self.locationsTableView.dataSource = self.tableDataSource
            self.locationsTableView.delegate = self.tableDataSource
            self.locationsTableView.reloadData()

        }

    }
}
