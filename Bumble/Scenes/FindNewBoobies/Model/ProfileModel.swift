//
//  ProfileModel.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import Foundation

class ProfileModel {
    let uid: String
    var name: String
    var school: String
    var bio: String
    var imageUrl: String
    var listPeopleILiked: [String]
    var listPeopleLikedMe: [String]
    var listMatch: [String]
    
    init(uid: String, name: String, school: String, bio: String, imageUrl: String, listPeopleILiked: [String], listPeopleLikedMe: [String], listMatch: [String]) {
        self.uid = uid
        self.name = name
        self.school = school
        self.bio = bio
        self.imageUrl = imageUrl
        self.listPeopleILiked = listPeopleILiked
        self.listPeopleLikedMe = listPeopleLikedMe
        self.listMatch = listMatch
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "name": name,
            "school": school,
            "bio": bio,
            "imageUrl": imageUrl,
            "listPeopleILiked": listPeopleILiked,
            "listPeopleLikedMe": listPeopleLikedMe,
            "listMatch": listMatch
        ]
    }
}

class LastestChatModel {
    let uid: String
    var name: String
    var imageUrl: String
    var lastMessage: String
    
    init(uid: String, name: String, imageUrl: String, lastMessage: String) {
        self.uid = uid
        self.name = name
        self.imageUrl = imageUrl
        self.lastMessage = lastMessage
    }
    
}


