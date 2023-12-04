//
//  ForgotPasswordVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 04/12/2023.
//

import UIKit
import FirebaseAuth
class ForgotPasswordVC: BaseViewController {
    @IBOutlet weak var gmailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var currentPasswordField: UITextField!
    var gmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    private func setupUI() {
        forgotPasswordView.layer.shadowColor = UIColor.black.cgColor
        forgotPasswordView.layer.shadowOpacity = 0.5
        forgotPasswordView.layer.shadowOffset = CGSize(width: 2, height: 2)
        forgotPasswordView.layer.shadowRadius = 4
        forgotPasswordView.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGesture)
        gmailField.text = gmail ?? ""
        currentPasswordField.isSecureTextEntry = true
        newPasswordField.isSecureTextEntry = true
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func backToLogin () {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideCurrentPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        currentPasswordField.isSecureTextEntry = sender.isSelected
        if !sender.isSelected {
            sender.setImage(UIImage(named: "view"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "hide"), for: .normal)
        }
    }
    
    @IBAction func hideNewPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        newPasswordField.isSecureTextEntry = sender.isSelected
        if !sender.isSelected {
            sender.setImage(UIImage(named: "view"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "hide"), for: .normal)
        }
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectButtonConfirm(_ sender: Any) {
        if !(currentPasswordField.text?.isEmpty ?? true) {
            if currentPasswordField.text == newPasswordField.text {
                if let user = Auth.auth().currentUser {
                    let newPassword = newPasswordField.text ?? ""
                    user.updatePassword(to: newPassword) { (error) in
                        if let error = error {
                            print("Error changing password: \(error.localizedDescription)")
                            let alert = UIAlertController(title: "Password Change", message: error.localizedDescription, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        } else {
                            let alert = UIAlertController(title: "Password Change", message: "Password changed successfully!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            print("Password changed successfully!")
                        }
                    }
                } else {
                    print("No signed-in user.")
                }
            } else {
                let alert = UIAlertController(title: "Password Change", message: "Failed to change password.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        present(alert, animated: true, completion: nil)
            }
        }
    }
}
