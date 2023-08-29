//
//  ChatVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 29/08/2023.
//

import UIKit
import MessageKit
import MessageInputBar

class ChatVC: BaseViewController {
    var messages: [Message] = []
    var member: Member!
    var messagesCollectionView: MessagesCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        member = Member(name: "summerfire", color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatVC: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func currentSender() -> SenderType {
        return sdType(senderId: member.name, displayName: member.name)
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ChatVC: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

extension ChatVC: MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}

extension ChatVC: MessageInputBarDelegate {
  func messageInputBar(
    _ inputBar: MessageInputBar,
    didPressSendButtonWith text: String) {
    
    let newMessage = Message(
      member: member,
      text: text,
      messageId: UUID().uuidString)
      
    messages.append(newMessage)
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    messagesCollectionView.scrollToBottom(animated: true)
  }
}




