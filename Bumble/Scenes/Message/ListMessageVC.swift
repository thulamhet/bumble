//
//  ListMessageVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 21/10/2023.
//

import UIKit

class ListMessageVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var matchList: [String] = ["woman10", "woman11","woman12", "woman13"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        layout.minimumInteritemSpacing = 20.0
//        layout.estimatedItemSize = CGSize(width: 80, height: 80)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "MatchQueueCollectionViewCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "MatchQueueCollectionViewCell")
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
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchQueueCollectionViewCell", for: indexPath) as? MatchQueueCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(matchList[indexPath.row])
        cell.cornerRadius = 40
        cell.borderWidth = 2
        cell.borderColor = .orange
        
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
