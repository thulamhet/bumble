//
//  ProfileView.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 10/07/2023.
//

import UIKit

class ProfileView: BaseLoadCustomView {
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateAvt (img: UIImage) {
        profileImg.image = img
    }
    
    func updateInfo(data: ProfileModel) {
        bioLabel.text = data.bio
        schoolLabel.text = data.school
        nameLabel.text = data.name
    }

}
