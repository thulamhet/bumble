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
    let bio: String = "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might. Maybe they’ll say that a match needs to know how much time you spend working out, so you might then write something like, “Looking for someone who enjoys gym dates” in your bio. "
    var listProfile: [ProfileModel] = [
        ProfileModel(name: "Lan", school: "VNU", bio: "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might.  "),
        ProfileModel(name: "Ngoc", school: "UET", bio: "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might."),
        ProfileModel(name: "Huyen", school: "VNG", bio: "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might."),
        ProfileModel(name: "Cutr", school: "CCG", bio: "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might."),
        ProfileModel(name: "Elizaxua", school: "WWE", bio: "If you’re truly stumped on how to describe yourself or your interests, ask your friends or family what key things they think a date should know about you. They won’t overthink it in the same way you might."),
    ]
    @IBOutlet weak var kolodaView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        kolodaView.reloadData()
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
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let vc = MatchedVC()
            vc.updateAvt(images[index])
            self.present(vc, animated: true)
        }
    }
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
}
