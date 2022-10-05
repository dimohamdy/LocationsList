//
//  UICollectionView+ReusableCell.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: CellReusable>(for indexPath: IndexPath) -> T? {
        return self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }
}
