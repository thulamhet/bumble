//
//  ProfileModel.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import Foundation
class ProfileModel {
    let name: String
    let school: String
    let bio: String
    init(name: String, school: String, bio: String) {
        self.name = name
        self.school = school
        self.bio = bio
    }
}
