//
//  InterestedVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit

class InterestedVC: UIViewController {
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var matchList: [String] = ["woman10", "woman11","woman12", "woman13", "woman13"]
    let firestoreManager = FirestoreManager()
    var listUser: [ProfileModel] = []
    var currentUser: ProfileModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        emptyView.isHidden = true
        getListPeopleLikeMe()
        self.currentUser = SESSION.currentUser
    }
    
    private func getListPeopleLikeMe() {
        let listLikeMe: [String] = SESSION.currentUser?.listPeopleLikedMe ?? []
        for id in listLikeMe {
            for user in SESSION.allUsers {
                if id == user.uid {
                    listUser.append(user)
                }
            }
        }
        if listUser.isEmpty {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
    }
    
    private func setupView() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "InterestedCollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "InterestedCollectionViewCell")
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension InterestedVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestedCollectionViewCell", for: indexPath) as? InterestedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(listUser[indexPath.row].imageUrl)
        cell.cornerRadius = 10
        
        cell.performLike = {
            let vc = MatchVC()
            vc.updateAvt(self.listUser[indexPath.row].imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
            
            // Thêm id vừa quẹt vào listMatch của user hiện tại
            self.currentUser?.listMatch.append(self.listUser[indexPath.row].uid)
            
            // Xóa id khỏi list thích mình
            self.currentUser?.listPeopleLikedMe = self.currentUser?.listPeopleLikedMe.filter {
                $0 != self.listUser[indexPath.row].uid
            } ?? []
            
            self.listUser = self.listUser.filter {
                $0.uid != self.listUser[indexPath.row].uid
            }
            collectionView.reloadData()
            if self.listUser.isEmpty {
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
            
            // Update user
            self.firestoreManager.updateUserProfile(userProfile: self.currentUser!)
            
            // Xóa id khỏi list đã thích của user vừa quẹt phải và thêm id vào list match
            var peopleISwiped: ProfileModel?
            self.self.firestoreManager.getUserProfile(uid: self.listUser[indexPath.row].uid) {[weak self] user in
                peopleISwiped = user
                guard let people = peopleISwiped else {return}
                people.listPeopleILiked = people.listPeopleILiked.filter {
                    $0 != self?.currentUser!.uid
                }
                people.listMatch.append((self?.currentUser!.uid)! )
                self?.firestoreManager.updateUserProfile(userProfile: people)
            }
            
            return
        }
        
        cell.performDislike = {
            //Xoa id khoi list thich minh
            self.currentUser?.listPeopleLikedMe = self.currentUser?.listPeopleLikedMe.filter {
                $0 != self.listUser[indexPath.row].uid
            } ?? []
            
            self.listUser = self.listUser.filter {
                $0.uid != self.listUser[indexPath.row].uid
            }
            collectionView.reloadData()
            if self.listUser.isEmpty {
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (SCREEN_WIDTH - 70)/2, height: 200)
        }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
