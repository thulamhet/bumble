//
//  ProfileView.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 10/07/2023.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import SDWebImage

class ProfileView: BaseLoadCustomView {
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var basicsStackView: UIStackView!
    @IBOutlet weak var interestStackView: UIStackView!
    
    var performLike: (() -> Void)?
    var performDislike: (() -> Void)?
    var imgUrl: String?
    var currentRowStackView: UIStackView?
    var basics: [String] = ["photography", "cooking", "dogs", "asdwd9wd", "wdwajdiwd"]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        SDWebImageManager.shared.loadImage(with: URL(string: imgUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.profileImg.image = image
        }
        let st = rowStackView()
        let ab = rowStackView2()
        basicsStackView.addArrangedSubview(st)
        interestStackView.addArrangedSubview(ab)
    }
    
    private func setupBasics () {
        
    }
    
    func rowStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        let a = InforCell()
        a.frame = CGRect(x: 40, y: 0, width: a.calculateWidth(), height: 30)
        a.setupUI("Don't know yet", "searchIcon")
        stackView.addArrangedSubview(a)
        
        let b = InforCell()
        b.frame = CGRect(x: 40, y: 0, width: a.calculateWidth(), height: 30)
        b.setupUI("Active", "gymIcon")
        stackView.addArrangedSubview(b)
        
        let view = UIView()
        stackView.addArrangedSubview(view)
        return stackView
    }
    
    func rowStackView2() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        let a = InforCell()
        a.frame = CGRect(x: 40, y: 0, width: a.calculateWidth(), height: 30)
        a.setupUI("Gym", "manLifting")
        stackView.addArrangedSubview(a)
        
        let b = InforCell()
        b.frame = CGRect(x: 40, y: 0, width: a.calculateWidth(),  height: 30)
        b.setupUI("Dancing", "womanDancing")
        stackView.addArrangedSubview(b)
        
        let view = UIView()
        stackView.addArrangedSubview(view)
        return stackView
    }
    
    func updateInfo(data: ProfileModel) {
        bioLabel.text = data.bio
        schoolLabel.text = data.school
        nameLabel.text = data.name
        imgUrl = data.imageUrl
    }
    
    @IBAction func didSelectButtonDislike(_ sender: Any) {
        performLike?()
    }
    
    
    @IBAction func didSelectButtonLike(_ sender: Any) {
        performDislike?()
    }
}

