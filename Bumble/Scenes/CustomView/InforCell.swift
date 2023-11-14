//
//  InforCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 13/11/2023.
//

import UIKit

class InforCell: BaseLoadCustomView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func calculateWidth() -> CGFloat {
        return titleLabel.intrinsicContentSize.width + 45
    }
    
    func setupUI (_ title: String, _ iconName: String) {
        titleLabel.text = title
        icon.image = UIImage(named: iconName)
    }
}
