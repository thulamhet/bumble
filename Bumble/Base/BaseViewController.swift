//
//  BaseViewController.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 19/07/2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        self.navigationController?.isNavigationBarHidden = true
    }
}
