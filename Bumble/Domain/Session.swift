//
//  Session.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 14/11/2023.
//

import Foundation

class SessionCache {
    static let shared = SessionCache()

    private init() {}

    var currentUser: ProfileModel?
    var allUsers: [ProfileModel] = []
}

let SESSION = SessionCache.shared
