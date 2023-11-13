//
//  ProfileModel.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import Foundation

class ProfileModel {
    let uid: String
    let name: String
    let school: String
    let bio: String
    let imageUrl: String
    
    init(uid: String, name: String, school: String, bio: String, imageUrl: String) {
        self.uid = uid
        self.name = name
        self.school = school
        self.bio = bio
        self.imageUrl = imageUrl
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "name": name,
            "school": school,
            "bio": bio,
            "imageUrl": imageUrl
        ]
    }
}


