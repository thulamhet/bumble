//
//  ChatViewController.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/10/2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentUser: ProfileModel? = SESSION.currentUser
    var user2: ProfileModel?
    
    private var docReference: DocumentReference?
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user2?.name
        maintainPositionOnKeyboardFrameChanged = true
        scrollsToLastItemOnKeyboardBeginsEditing = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemTeal, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        customNavBar()
        loadChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func customNavBar () {
        let backImg = UIImage(named: "ic24PxOutlineLeft")
        self.navigationController?.navigationBar.backIndicatorImage = backImg
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImg
        self.navigationController?.navigationBar.backItem?.title = ""
//        self.navigationController?.navigationBar.tintColor = .black
//        self.navigationController?.navigationBar.backgroundColor = .white
        
        let titleView = UIView()

        let imageView = UIImageView(image: UIImage(named: "ic24PxOutlineLeft"))
        imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Custom messages handlers
    func createNewChat() {
        let users = [self.currentUser?.uid ??  "", user2?.uid ?? ""]
         let data: [String: Any] = [
             "users":users
         ]
         
         let db = Firestore.firestore().collection("Chats")
         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }
    }
    
    func loadChat() {
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if chat?.users.contains(self.user2?.uid ?? "") == true {
//                        if (true) {
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {
                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg ?? Message(id: "123", content: "No message found", created: Date(), senderID: "123", senderName: "nihao"))
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                }
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
        }
    }
    
    private func save(_ message: Message) {
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            
        })
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
            func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
                let message = Message(id: UUID().uuidString, content: text, created: Date(), senderID: currentUser?.uid ?? "", senderName: currentUser?.name ?? "" )
                  //messages.append(message)
                  insertNewMessage(message)
                  save(message)
    
                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                messagesCollectionView.scrollToLastItem(animated: true)
            }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        // ??
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            print("There are \(messages.count) messages")
            return messages.count
        }
    }
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(hexString: "#F6C84F") : .lightGray
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if message.sender.senderId == currentUser?.uid {
            SDWebImageManager.shared.loadImage(with: URL(string: currentUser?.imageUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        } else {
            SDWebImageManager.shared.loadImage(with: URL(string: user2?.imageUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                avatarView.image = image
            }
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}
