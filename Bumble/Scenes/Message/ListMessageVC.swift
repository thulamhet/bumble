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
    let firestoreManager = FirestoreManager()
    let user: User = Auth.auth().currentUser!
    var matchList: [String] = ["woman10", "woman11","woman12", "woman13"]
    var currentUser: ProfileModel?
    var listUidMatch: [String] = []
    var listUserMatch: [ProfileModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        currentUser = SESSION.currentUser
        getListMatch()
    }
    
    private func getListMatch() {
        listUidMatch = findCommonElements(arrayA: currentUser?.listPeopleILiked ?? [], arrayB: currentUser?.listPeopleLikedMe ?? [])
        for id in listUidMatch {
            for user in SESSION.allUsers {
                if id == user.uid {
                    listUserMatch.append(user)
                }
            }
        }
        collectionView.reloadData()
    }
    
    private func setupView () {
        configureCollectionView()
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
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTemp(_ sender: Any) {
        let vc = ChatViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
}


