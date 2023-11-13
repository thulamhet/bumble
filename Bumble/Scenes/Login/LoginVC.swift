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
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            print("Missing field data")
            return
        }
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = "Ngoc trinh"
        changeRequest?.photoURL = URL(string: "https://people.com/thmb/f96tuDus6iHbftSvPZjYpMAsTCk=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(777x504:779x506)/petting-dog-080323-1-b4440cd8468c4242b3a707dbcb415120.jpg")
        changeRequest?.commitChanges { error in
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { result, error in
            guard error == nil else {
                return
            }
            print("You have signed in")
            let vc = FindNewVC()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
}
