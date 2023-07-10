//
//  FindNewVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 06/07/2023.
//

import UIKit
import Koloda

class FindNewVC: UIViewController {
    @IBOutlet weak var scrollView: UIView!
    var images: [String] = ["bee", "background", "fox", "bee"]
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
    
}

extension FindNewVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return images.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let view = UIImageView(image: UIImage(named: images[index]))
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
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
