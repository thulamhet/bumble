//
//  MatchedVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 08/11/2023.
//

import UIKit
import FirebaseFirestore
import Firebase
import SDWebImage

class MatchedVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var herImage: UIImageView!
    @IBOutlet weak var yourImg: UIImageView!
    var herUrl: String = ""
    var currentUser: User = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView () {
        titleLabel.text = "CONGRATULATION \n it's Match"
        SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.yourImg.image = image
        }
        SDWebImageManager.shared.loadImage(with: URL(string: herUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.herImage.image = image
        }
    }
    
    func updateAvt (_ imgUrl: String) {
        self.herUrl = imgUrl
    }
    
    @IBAction func didSelectBackGround(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
