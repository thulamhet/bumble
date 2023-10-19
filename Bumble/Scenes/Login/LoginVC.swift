//
//  LoginVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 29/06/2023.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginVC: UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.container.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        emailField.becomeFirstResponder()
    }
    
    private func setupUI() {
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOpacity = 0.5
        loginView.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginView.layer.shadowRadius = 4
        loginView.layer.cornerRadius = 8
    }

    @IBAction func didSelectCreateNew(_ sender: Any) {
//        FirebaseAuth.Auth.auth().createUser(withEmail: "a@gmail.com", password: "123456")
    }
    @IBAction func didSelectLoginBtn(_ sender: Any) {
//        Auth.auth().signInAnonymously()
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        GIDSignIn.sharedInstance.signOut()
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                return
            }
            print("You have signed in")
//            let vc = FindNewVC()
            let vc = ChatViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
}
