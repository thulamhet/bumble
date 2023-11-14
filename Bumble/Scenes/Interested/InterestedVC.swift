//
//  InterestedVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit

class InterestedVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var matchList: [String] = ["woman10", "woman11","woman12", "woman13", "woman13"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        self.dismiss(animated: true)
    }
    
}

extension InterestedVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestedCollectionViewCell", for: indexPath) as? InterestedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(matchList[indexPath.row])
        cell.cornerRadius = 10
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