//
//  MatchQueueCollectionViewCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 21/10/2023.
//

import UIKit

class MatchQueueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avtImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell (_ img: UIImage) {
        avtImage.image = img
    }

}
