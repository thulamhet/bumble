//
//  Message.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import UIKit
import Firebase
import MessageKit
import Foundation

struct Message {
    var id: String
    var content: String
    var created: Date
    var senderID: String
    var senderName: String
    var dictionary: [String: Any] {
        return [
            "id": id,
            "content": content,
//            "created": created,
            "senderID": senderID,
            "senderName":senderName]
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let content = dictionary["content"] as? String,
              let created = dictionary["created"] as? Date,
              let senderID = dictionary["senderID"] as? String,
              let senderName = dictionary["senderName"] as? String
        else {return nil}
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return ChatUser(senderId: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}
