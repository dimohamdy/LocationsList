//
//  UIView+Loading.swift
//  LocationsList
//
//  Created by Dimo Abdelaziz on 30/09/2022.
//

import Foundation
import UIKit

enum Tags {
    enum Loading: Int {
        case defaultLoadingIndicator = 999999
    }
}

extension UIView {
    private var loadingIndicatorView: UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style = .medium
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.color = .systemPink
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }

    func showLoadingIndicator(tag: Tags.Loading = Tags.Loading.defaultLoadingIndicator, _ backgroundAlpha: CGFloat = 0.3) {
        guard viewWithTag(tag.rawValue) == nil else {
            if let loadingIndicator = viewWithTag(tag.rawValue) as? UIActivityIndicatorView {
                loadingIndicator.startAnimating()
            }
            return
        }

        let height: CGFloat = 45

        let loadingView = loadingIndicatorView
        loadingView.tag = tag.rawValue
        loadingView.backgroundColor = .secondarySystemBackground.withAlphaComponent(backgroundAlpha)
        loadingView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        loadingView.layer.cornerRadius = height * 0.2
        addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalToConstant: height),
            loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        layoutIfNeeded()

        loadingView.startAnimating()

    }

    func dismissLoadingIndicator(tag: Tags.Loading =  Tags.Loading.defaultLoadingIndicator) {

        DispatchQueue.main.async(execute: { [weak self] in
            guard let self = self else { return }
            while self.viewWithTag(tag.rawValue) != nil {
                self.viewWithTag(tag.rawValue)?.removeFromSuperview()
            }
        })
    }

}

extension UIViewController {

    func showLoadingIndicator() {
        view.showLoadingIndicator()
    }

    func dismissLoadingIndicator() {
        view.dismissLoadingIndicator()
    }
}
