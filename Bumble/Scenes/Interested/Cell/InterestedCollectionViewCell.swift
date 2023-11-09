//
//  InterestedCollectionViewCell.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit

class InterestedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatarImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(_ img: String) {
        avatarImg.image = UIImage(named: img)
    }

    @IBAction func didSelectLikeButton(_ sender: Any) {
        
    }
}
