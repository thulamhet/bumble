//
//  Message.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 29/08/2023.
//

import Foundation
import UIKit
import MessageKit

struct Member {
    let name: String
    let color: UIColor
}

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

struct sdType :SenderType {
    let senderId: String
    let displayName: String
    
    init(senderId: String, displayName: String) {
        self.senderId = senderId
        self.displayName = displayName
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return sdType(senderId: member.name, displayName: member.name)
    }

    var sentDate: Date {
        return Date()
    }

    var kind: MessageKind {
    return .text(text)
    }
}
