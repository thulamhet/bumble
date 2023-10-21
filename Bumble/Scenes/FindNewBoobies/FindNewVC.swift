//
//  FindNewVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import UIKit
import Koloda
class FindNewVC: BaseViewController {
    @IBOutlet weak var scrollView: UIView!
    var images: [String] = ["woman7", "woman2", "woman3", "woman7", "woman5"]
    var listProfile: [ProfileModel] = [
        ProfileModel(name: "Lan", school: "VNU", bio: "no nsia asdasd"),
        ProfileModel(name: "Ngoc", school: "UET", bio: "vxc  vxc vxc v xcvxc"),
        ProfileModel(name: "Huyen", school: "VNG", bio: "wwweq  qwqw qw "),
        ProfileModel(name: "Cutr", school: "CCG", bio: "dassdasdasczxcdasd"),
        ProfileModel(name: "Elizaxua", school: "WWE", bio: "dassdasdasdasd"),
    ]
    @IBOutlet weak var kolodaView: KolodaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.reloadData()
    }

    private func setupView () {
        
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectMessageButton(_ sender: Any) {
        let vc = ListMessageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension FindNewVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return images.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = ProfileView()
        view.updateAvt(img: UIImage(named: images[index]) ?? UIImage())
        view.updateInfo(data: listProfile[index])
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
       let alert = UIAlertController(title: "Congratulation!", message: "Now you're \(images[index])", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default))
       self.present(alert, animated: true)
    }
    
}
