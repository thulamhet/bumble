//
//  ChatUser.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
