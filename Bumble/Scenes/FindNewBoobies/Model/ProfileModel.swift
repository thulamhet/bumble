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
    var age: String
    var gender: String
    
    init(uid: String, name: String, school: String, bio: String, imageUrl: String, listPeopleILiked: [String], listPeopleLikedMe: [String], listMatch: [String], age: String, gender: String) {
        self.uid = uid
        self.name = name
        self.school = school
        self.bio = bio
        self.imageUrl = imageUrl
        self.listPeopleILiked = listPeopleILiked
        self.listPeopleLikedMe = listPeopleLikedMe
        self.listMatch = listMatch
        self.age = age
        self.gender = gender
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
            "listMatch": listMatch,
            "age": age,
            "gender": gender
        ]
    }
}

class LastestChatModel {
    let uid: String
    var name: String
    var imageUrl: String
    var lastMessage: Message
    var yourTurn: Bool
    init(uid: String, name: String, imageUrl: String, lastMessage: Message, yourTurn: Bool) {
        self.uid = uid
        self.name = name
        self.imageUrl = imageUrl
        self.lastMessage = lastMessage
        self.yourTurn = yourTurn
    }
    
}


