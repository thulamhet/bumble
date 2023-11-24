//
//  InterestedCollectionViewCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit
import SDWebImage

class InterestedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ imgUrl: String) {
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl ), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.avatarImg.image = image
        }
    }

    @IBAction func didSelectLikeButton(_ sender: Any) {
        
    }
}

