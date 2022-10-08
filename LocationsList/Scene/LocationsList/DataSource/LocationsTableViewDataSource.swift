//
//  LocationsTableViewDataSource.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

final class LocationsTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var tableSections: [TableViewSectionType] = []
    
    weak var presenterInput: LocationsListPresenterInput?
    
    private struct CellHeightConstant {
        static let heightOfLocationCell: CGFloat = 50
        static let heightOfHistoryHeader: CGFloat = 50
    }
    
    init(presenterInput: LocationsListPresenterInput?, tableSections: [TableViewSectionType]) {
        self.tableSections = tableSections
        self.presenterInput = presenterInput
    }
    
    // MARK: - UITableView view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = tableSections[section]
        switch section {
        case .online(let locations), .local(let locations):
            return locations.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = tableSections[indexPath.section]
        switch section {
        case .online(let locations), .local(let locations):
            if let cell: LocationTableViewCell = tableView.dequeueReusableCell(for: indexPath) {
                cell.configCell(location: locations[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = tableSections[indexPath.section]
        switch section {
        case .online(let locations), .local(let locations) :
            presenterInput?.open(location: locations[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellHeightConstant.heightOfLocationCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CellHeightConstant.heightOfHistoryHeader
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTableHeader.identifier) as? GeneralTableHeader else {
            return nil
        }
        let section = tableSections[section]
        switch section {
        case .online:
            headerCell.headerLabel.text = Strings.onlineTitle.localized()
        case .local :
            headerCell.headerLabel.text = Strings.localTitle.localized()
        }

        return headerCell

    }
}
