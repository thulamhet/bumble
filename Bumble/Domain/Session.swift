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
    var filterStatus: Int = 2
    var filterAge: Int = 100
}

let SESSION = SessionCache.shared
