//
//  ListMessageVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 21/10/2023.
//

import UIKit

class ListMessageVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var matchList: [String] = ["woman4", "woman5","woman6", "woman7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        layout.estimatedItemSize = CGSize(width: 100, height: 104)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MatchQueueCollectionViewCell.self, forCellWithReuseIdentifier: "MatchQueueCollectionViewCell")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListMessageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchQueueCollectionViewCell", for: indexPath) as? MatchQueueCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(UIImage(named: matchList[indexPath.row]) ?? UIImage())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // we want a 1-pt border on top, bottom and left and right edges of the collection view itself
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
}
