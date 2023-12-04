//
//  FindNewVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import UIKit
import Koloda
import Firebase
import CoreLocation

class FindNewVC: BaseViewController, CLLocationManagerDelegate {
    @IBOutlet weak var scrollView: UIView!
    
    var listProfile: [ProfileModel] = []
    let firestoreManager = FirestoreManager()
    var currentUser: ProfileModel?
    
    @IBOutlet weak var kolodaView: KolodaView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        let user: User = Auth.auth().currentUser!
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.reloadData()
        self.locationManager.requestAlwaysAuthorization()
        
        
//        var a = ProfileModel(uid: "vf19aaqw7WRI3ymA2J9mQ6XcZZH3", name: "Minh", school: "VNU", bio: "đây là a9@gmail.com", imageUrl: "https://pics.craiyon.com/2023-07-06/9ba84ae991974741b13d6d3d0a4898b9.webp", listPeopleILiked: [], listPeopleLikedMe: [], listMatch: [])
//        firestoreManager.saveUserProfile(userProfile: a)
        getListUsers()
        if (self.currentUser == nil) {
            firestoreManager.getUserProfile(uid: user.uid, completion: { [weak self] user in
                self?.currentUser = user
                SESSION.currentUser = user
            })
        }
    }
    
    private func getListUsers() {
        LoadingView.show()
        firestoreManager.getAllUsers { [weak self] profiles in
            self?.listProfile = profiles
            SESSION.allUsers = profiles
            self?.kolodaView.reloadData()
            LoadingView.hide()
        }
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        let vc = ProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
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
            if (currentUser?.listPeopleLikedMe.contains(listProfile[index].uid) ?? false) {
                let vc = MatchVC()
                vc.updateAvt(listProfile[index].imageUrl)
                self.navigationController?.pushViewController(vc, animated: true)
                
                // Thêm id vừa quẹt vào listMatch của user hiện tại
                currentUser?.listMatch.append(listProfile[index].uid)
                
                // Xóa id khỏi list thích mình
                currentUser?.listPeopleLikedMe = currentUser?.listPeopleLikedMe.filter {
                    $0 != listProfile[index].uid
                } ?? []
                
                // Update user
                firestoreManager.updateUserProfile(userProfile: self.currentUser!)
                
                // Xóa id khỏi list đã thích của user vừa quẹt phải và thêm id vào list match
                var peopleISwiped: ProfileModel?
                firestoreManager.getUserProfile(uid: listProfile[index].uid) {[weak self] user in
                    peopleISwiped = user
                    guard let people = peopleISwiped else {return}
//                    if !people.listPeopleILiked.contains((self?.currentUser!.uid)!) {
//                        people.listPeopleILiked.append(self!.currentUser!.uid)
//                        people.listPeopleILiked = people.listPeopleILiked.filter {
//                            $0 != self?.currentUser!.uid
//                        }
//
//                        people.listMatch.append((self?.currentUser!.uid)! )
//                        self?.firestoreManager.updateUserProfile(userProfile: people)
//                    }
                    people.listPeopleILiked = people.listPeopleILiked.filter {
                        $0 != self?.currentUser!.uid
                    }
                    people.listMatch.append((self?.currentUser!.uid)! )
                    self?.firestoreManager.updateUserProfile(userProfile: people)
                }
                
                return
            }
            
            // Update list những người đã thích cho user hiện tại
            if !(currentUser?.listPeopleILiked.contains(listProfile[index].uid) ?? false) {
                currentUser?.listPeopleILiked.append(listProfile[index].uid)
            }
            firestoreManager.updateUserProfile(userProfile: self.currentUser!)
            
            // Update list những người thích mình cho user vừa quẹt
            var peopleISwiped: ProfileModel?
            firestoreManager.getUserProfile(uid: listProfile[index].uid) {[weak self] user in
                peopleISwiped = user
                guard let people = peopleISwiped else {return}
                if !people.listPeopleLikedMe.contains((self?.currentUser!.uid)!) {
                    people.listPeopleLikedMe.append(self!.currentUser!.uid)
                    self?.firestoreManager.updateUserProfile(userProfile: people)
                }
            }
        } else {
            
        }
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
}
