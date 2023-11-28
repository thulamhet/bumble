//
//  ProfileVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 28/11/2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

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

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func didSelectUploadAvatar(_ sender: Any) {
        pickImage()
    }
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ProfileVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Call the function to upload the image to Firebase
            uploadImageToFirebase(image: pickedImage) { result in
                switch result {
                case .success(let downloadURL):
                    print("Image uploaded successfully. Download URL: \(downloadURL)")
                    // Do something with the download URL, like saving it to a database or displaying it in your app
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
}
