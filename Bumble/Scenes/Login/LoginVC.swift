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
//        emailField.becomeFirstResponder()
    }
    
    private func setupUI() {
        loginView.layer.shadowColor = UIColor.black.cgColor
        loginView.layer.shadowOpacity = 0.5
        loginView.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginView.layer.shadowRadius = 4
        loginView.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGesture)
        passwordField.isSecureTextEntry = true
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

    @IBAction func didSelectCreateNew(_ sender: Any) {
//        FirebaseAuth.Auth.auth().createUser(withEmail: "a@gmail.com", password: "123456")
    }
    
    @IBAction func didSelectEyeButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        passwordField.isSecureTextEntry = sender.isSelected
        if !sender.isSelected {
            sender.setImage(UIImage(named: "view"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "hide"), for: .normal)
        }
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
                let alert = UIAlertController(title: "Login Failed", message: "Incorrect username or password. Please try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("You have signed in")
            let vc = FindNewVC()
//            let vc = MatchVC()
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    @IBAction func didSelectForgotPassword(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.gmail = emailField.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
