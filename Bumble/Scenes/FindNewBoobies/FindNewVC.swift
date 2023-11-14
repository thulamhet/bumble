//
//  FindNewVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import UIKit
import Koloda
import Firebase

class FindNewVC: BaseViewController {
    @IBOutlet weak var scrollView: UIView!
    
    var listProfile: [ProfileModel] = []
    let firestoreManager = FirestoreManager()
    var currentUser: ProfileModel?
    
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: User = Auth.auth().currentUser!
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.reloadData()
//        var a = ProfileModel(uid: "dD0hAHU3hQU2RrfpbkoJ645diYL2", name:"thư", school: "UET", bio: "wqddasdasdasdasadasass", imageUrl: "https://images5.alphacoders.com/126/1266052.jpg")
//            firestoreManager.saveUserProfile(userProfile: a)
        getListUsers()
        if (self.currentUser == nil) {
            firestoreManager.getUserProfile(uid: user.uid, completion: { [weak self] user in
                self?.currentUser = user
            })
        }
    }
    
    private func getListUsers() {
        LoadingView.show()
        firestoreManager.getAllUsers { [weak self] profiles in
            self?.listProfile = profiles
            self?.kolodaView.reloadData()
            LoadingView.hide()
        }
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectMessageButton(_ sender: Any) {
        let vc = ListMessageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didSelectFilterButton(_ sender: Any) {
        let vc = FilterVC()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func didSelectInterestedButton(_ sender: Any) {
        let vc = InterestedVC()
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
    }
}

extension FindNewVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return listProfile.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = ProfileView()
        if listProfile.count > 0 {
            view.updateInfo(data: listProfile[index])
        }
        view.performLike = {
            self.kolodaView.swipe(.left)
        }
        view.performDislike = {
            self.kolodaView.swipe(.right)
        }
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .slow
    }
}

extension FindNewVC: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
       koloda.reloadData()
    }

    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        if listProfile.count > 0 {
            let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(listProfile[index].name)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let vc = MatchedVC()
            vc.updateAvt(listProfile[index].imageUrl)
            self.present(vc, animated: true)
            
            //Update list you liked for current user
            if !(currentUser?.listPeopleILiked.contains(listProfile[index].uid) ?? false) {
                currentUser?.listPeopleILiked.append(listProfile[index].uid)
            }
            firestoreManager.updateUserProfile(userProfile: self.currentUser!)
            
            //Update list who liked you for swiped right user
            var peopleISwiped: ProfileModel?
            firestoreManager.getUserProfile(uid: listProfile[index].uid) {[weak self] user in
                peopleISwiped = user
                guard let people = peopleISwiped else {return}
                if !people.listPeopleLikedMe.contains((self?.currentUser!.uid)!) {
                    people.listPeopleLikedMe.append(self!.currentUser!.uid)
                    self?.firestoreManager.updateUserProfile(userProfile: people)
                }
            }
        }
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
}
