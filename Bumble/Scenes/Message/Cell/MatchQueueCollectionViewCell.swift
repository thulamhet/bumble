//
//  MatchQueueCollectionViewCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 21/10/2023.
//

import UIKit
import SDWebImage

class MatchQueueCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell (_ imgUrl: String) {
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.image.image = image
        }
    }
}
