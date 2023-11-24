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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(_ imgUrl: String, _ name: String, _ mes: String) {
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl ), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.avatarImg.image = image
        }
        
        nameLabel.text = name
        mesLabel.text = mes
    }
    
}
