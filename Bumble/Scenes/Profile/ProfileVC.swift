//
//  ProfileVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 28/11/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import FirebaseAuth

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var avtImage: UIImageView!
    @IBOutlet weak var bioDesView: UITextView!
    
    let firestoreManager = FirestoreManager()
    var currentUser: ProfileModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = SESSION.currentUser
        setupView()
    }
    
    private func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupView() {
        SDWebImageManager.shared.loadImage(with: URL(string: SESSION.currentUser?.imageUrl ?? ""), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            self.avtImage.image = image
        }
        bioDesView.text = currentUser?.bio ?? ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func didSelectUploadAvatar(_ sender: Any) {
        pickImage()
    }
    
    @IBAction func didSelectButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectSignOutBtn(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("User signed out successfully")
            let vc = LoginVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out:", signOutError.localizedDescription)
        }
    }
    @IBAction func didSelectButtonChangePassword(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.gmail = Auth.auth().currentUser?.email
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didSelectButtonSave(_ sender: Any) {
        currentUser?.bio = bioDesView.text
        firestoreManager.updateUserProfile(userProfile: currentUser!)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Call the function to upload the image to Firebase
            LoadingView.show()
            uploadImageToFirebase(image: pickedImage) { [weak self] result in
                LoadingView.hide()
                switch result {
                case .success(let downloadURL):
                    print("Image uploaded successfully. Download URL: \(downloadURL)")
                        SDWebImageManager.shared.loadImage(with: URL(string: downloadURL.absoluteString), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                            self?.avtImage.image = image
                            self?.currentUser?.imageUrl = downloadURL.absoluteString
                            self?.firestoreManager.updateUserProfile(userProfile: (self?.currentUser)!)
                        }
                    // Handle
                case .failure(let error):
                    print("Error uploading image: \(error.localizedDescription)")
                    // Handle the error
                }
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func uploadImageToFirebase(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "com.yourapp.error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }

        let imageID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(imageID).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
    //        if error == nil , let metadata = metadata {
    //             if let url = metadata.downloadURL()?.absoluteString {
    //                   //use this url to access your image
    //             }
    //        }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let downloadURL = url {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(NSError(domain: "com.yourapp.error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    
}
