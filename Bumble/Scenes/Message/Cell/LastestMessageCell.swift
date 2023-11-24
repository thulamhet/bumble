//
//  LastestMessageCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 24/11/2023.
//

import UIKit
import SDWebImage
class LastestMessageCell: UITableViewCell {
    @IBOutlet weak var mesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var unreadView: UIView!
    @IBOutlet weak var yourMoveView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ imgUrl: String, _ name: String, _ mes: String, _ yourMove: Bool) {
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl ), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.avatarImg.image = image
        }
        yourMoveView.isHidden = !yourMove
        unreadView.isHidden = !yourMove
        nameLabel.text = name
        mesLabel.text = mes
    }
    
}
