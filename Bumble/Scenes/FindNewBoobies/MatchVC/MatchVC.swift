//
//  MatchVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 14/11/2023.
//

import UIKit
import SDWebImage
import Firebase

class MatchVC: BaseViewController {
    @IBOutlet weak var currentUserImg: UIImageView!
    @IBOutlet weak var matchedUserImg: UIImageView!
    var herUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupView()
    }
    
    private func configureUI() {
        let rotationAngle: CGFloat = .pi / 16.0
        currentUserImg.transform = CGAffineTransform(rotationAngle: -rotationAngle)
        matchedUserImg.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func setupView () {
        SDWebImageManager.shared.loadImage(with: URL(string: SESSION.currentUser?.imageUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.currentUserImg.image = image
        }
        SDWebImageManager.shared.loadImage(with: URL(string: herUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.matchedUserImg.image = image
        }
    }
    
    func updateAvt (_ imgUrl: String) {
        self.herUrl = imgUrl
    }
    
    @IBAction func didSelectButtonClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
