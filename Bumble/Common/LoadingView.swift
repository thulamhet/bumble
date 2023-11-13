//
//  LoadingView.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 13/11/2023.
//

import Foundation
import UIKit

class LoadingView: UIView {

    private static let shared = LoadingView()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    class func show() {
        guard let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }

        keyWindow.addSubview(shared)

        shared.frame = keyWindow.bounds
        shared.activityIndicator.startAnimating()
    }

    class func hide() {
        shared.activityIndicator.stopAnimating()
        shared.removeFromSuperview()
    }
}
