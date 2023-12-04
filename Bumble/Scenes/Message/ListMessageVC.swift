//
//  ListMessageVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 21/10/2023.
//

import UIKit
import Firebase

class ListMessageVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var matchQueueText: UILabel!
    @IBOutlet weak var messageTableView: UITableView!
    let firestoreManager = FirestoreManager()
    let user: User = Auth.auth().currentUser!
    var matchList: [String] = ["woman10", "woman11","woman12", "woman13"]
    var currentUser: ProfileModel?
    var listUidMatch: [String] = []
    var listUserMatch: [ProfileModel] = []
    private var docReference: DocumentReference?
    var tableViewData : [LastestChatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentUser = SESSION.currentUser
        getListMatch()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewData.removeAll()
        getListLastMsg()
    }
    
    private func getListLastMsg () {
        for user in listUserMatch {
            loadChat(user)
        }
    }
    
    private func loadChat(_ user: ProfileModel) {
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: currentUser?.uid ?? "Not Found")
        
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    return
                }
                else if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        if chat?.users.contains(user.uid) == true {
                            self.docReference = doc.reference
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                let msgdata = threadQuery!.documents.last?.data()
                                if (msgdata != nil) {
                                    let msg = Message(dictionary: msgdata!)
                                    let yourTurn = msg?.senderID == self.currentUser?.uid ? false : true
                                    let lastMsg = LastestChatModel(uid: user.uid, name: user.name, imageUrl: user.imageUrl, lastMessage: msg!, yourTurn: yourTurn)
                                    if !self.tableViewData.contains(where: {
                                        $0.uid == lastMsg.uid
                                    }) {
                                        self.tableViewData.append(lastMsg)
                                        self.messageTableView.reloadData()
                                    } else {
                                        for mes in self.tableViewData {
                                            if mes.uid == lastMsg.uid && mes.lastMessage.id != lastMsg.lastMessage.id{
//                                                if let keyWindow = UIApplication.shared.keyWindow, let rootViewController = keyWindow.rootViewController {
//                                                    let customPopup = CustomPopup()
//                                                    customPopup.show(inView: rootViewController.view)
//                                                }
                                                
                                                mes.lastMessage = lastMsg.lastMessage
                                                mes.yourTurn = true
                                                for i in 0..<self.tableViewData.count {
                                                    for j in 0..<self.tableViewData.count - 1 - i {
                                                        if self.tableViewData[j].lastMessage.sentDate < self.tableViewData[j + 1].lastMessage.sentDate {
                                                            // Swap elements
                                                            let temp = self.tableViewData[j]
                                                            self.tableViewData[j] = self.tableViewData[j + 1]
                                                            self.tableViewData[j + 1] = temp
                                                        }
                                                    }
                                                }
                                                self.messageTableView.reloadData()
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            })
                            for i in 0..<self.tableViewData.count {
                                for j in 0..<self.tableViewData.count - 1 - i {
                                    if self.tableViewData[j].lastMessage.sentDate < self.tableViewData[j + 1].lastMessage.sentDate {
                                        // Swap elements
                                        let temp = self.tableViewData[j]
                                        self.tableViewData[j] = self.tableViewData[j + 1]
                                        self.tableViewData[j + 1] = temp
                                    }
                                }
                            }
                            self.messageTableView.reloadData()
                            return
                        }
                    }
                }
            }
        }
        
    }
    
    private func getListMatch() {
        listUidMatch = currentUser?.listMatch ?? []
        for id in listUidMatch {
            for user in SESSION.allUsers {
                if id == user.uid {
                    listUserMatch.append(user)
                }
            }
        }
        
        matchQueueText.text = "Match Queue (\(listUserMatch.count))"
        collectionView.reloadData()
    }
    
    private func setupView () {
        configureCollectionView()
        configureTableView()
    }
    
    private func configureTableView () {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        let nib = UINib(nibName: "LastestMessageCell", bundle: .main)
        messageTableView.register(nib, forCellReuseIdentifier: "LastestMessageCell")
    }
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "MatchQueueCollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "MatchQueueCollectionViewCell")
    }
    
    func findCommonElements(arrayA: [String], arrayB: [String]) -> [String] {
        let setA = Set(arrayA)
        let setB = Set(arrayB)
        let commonElements = Array(setA.intersection(setB))
        return commonElements
    }
    
    func getTopViewControllerName() -> String? {
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            var currentViewController: UIViewController = topViewController

            while let presentedViewController = currentViewController.presentedViewController {
                currentViewController = presentedViewController
            }

            return String(describing: type(of: currentViewController))
        }

        return nil
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ListMessageVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listUserMatch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchQueueCollectionViewCell", for: indexPath) as? MatchQueueCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(listUserMatch[indexPath.row].imageUrl)
        cell.cornerRadius = 40
        cell.borderWidth = 3
        cell.borderColor = UIColor(hexString: "#FFDF37")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 80, height: 80)
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.user2 = listUserMatch[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListMessageVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LastestMessageCell",
                                                       for: indexPath) as? LastestMessageCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        if (tableViewData.count > indexPath.row) {
            cell.setupCell(tableViewData[indexPath.row].imageUrl, tableViewData[indexPath.row].name, tableViewData[indexPath.row].lastMessage.content, tableViewData[indexPath.row].yourTurn)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatViewController()
        for user in listUserMatch {
            if tableViewData[indexPath.row].uid == user.uid {
                vc.user2 = user
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
    }
}


class CustomPopup: UIView {
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPopup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPopup()
    }
    
    private func setupPopup() {
        // Configure the popup view
        popupView.backgroundColor = UIColor.systemBlue
        popupView.layer.cornerRadius = 10
        popupView.clipsToBounds = true
        popupView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(popupView)
        
        // Add constraints to position the popup view with a distance of 10 from the top and 20 from the left
        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            popupView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            popupView.widthAnchor.constraint(equalToConstant: 200),
            popupView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Add a title label to the popup view
        titleLabel.text = "New Notification"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popupView.addSubview(titleLabel)
        
        // Add constraints to center the title label within the popup view
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor)
        ])
    }
    
    func show(inView view: UIView) {
        // Add the popup to the specified view
        view.addSubview(self)
        
        // Animate the popup into view
        alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
        
        // Hide the popup after a delay (you can adjust this based on your requirements)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.hide()
        }
    }
    
    private func hide() {
        // Animate the popup out of view
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }) { (_) in
            // Remove the popup from its superview after the animation completes
            self.removeFromSuperview()
        }
    }
}
