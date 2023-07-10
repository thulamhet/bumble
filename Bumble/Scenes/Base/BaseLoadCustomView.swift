//
//  BaseLoadCustomView.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 10/07/2023.
//

import UIKit

class BaseLoadCustomView: UIView {
    @IBOutlet weak var mainView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        let xibFileName = String(describing: type(of: self))
        Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)
        addSubview(mainView)
        constrantFitToSuperview()
    }

    private func constrantFitToSuperview() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
