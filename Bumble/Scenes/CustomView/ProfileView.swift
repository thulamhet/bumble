//
//  ProfileView.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 10/07/2023.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import SDWebImage

class ProfileView: BaseLoadCustomView {
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var performLike: (() -> Void)?
    var performDislike: (() -> Void)?
    var imgUrl: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.profileImg.image = image
        }
    }
    
    func updateInfo(data: ProfileModel) {
        bioLabel.text = data.bio
        schoolLabel.text = data.school
        nameLabel.text = data.name
        imgUrl = data.imageUrl
    }
    
    @IBAction func didSelectButtonDislike(_ sender: Any) {
        performLike?()
    }
    
    
    @IBAction func didSelectButtonLike(_ sender: Any) {
        performDislike?()
    }
    
}

