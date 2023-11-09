//
//  InterestedVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit

class InterestedVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
