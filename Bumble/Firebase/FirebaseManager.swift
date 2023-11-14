//
//  FirebaseManager.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 12/11/2023.
//

import FirebaseFirestore
import Firebase

class FirestoreManager {

    let db = Firestore.firestore()
    let currentUser: User = Auth.auth().currentUser!

    func saveUserProfile(userProfile: ProfileModel) {
        let userRef = db.collection("users").document(userProfile.uid)

        // Convert the profile model to a dictionary
        let data = userProfile.toDictionary()

        // Save the data to Firestore
        userRef.setData(data) { error in
            if let error = error {
                print("Error saving profile: \(error.localizedDescription)")
            } else {
                print("Profile saved successfully!")
            }
        }
    }

    func getUserProfile(uid: String, completion: @escaping (ProfileModel?) -> Void) {
        let userRef = db.collection("users").document(uid)

        // Retrieve the data from Firestore
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                // Convert Firestore data to UserProfile model
                if let data = document.data(),
                   let name = data["name"] as? String,
                   let school = data["school"] as? String,
                   let bio = data["bio"] as? String,
                   let imageUrl = data["imageUrl"] as? String,
                   let uid = data["uid"] as? String,
                   let iLiked = data["listPeopleILiked"] as? [String],
                   let likedMe = data["listPeopleLikedMe"] as? [String]
                {
                    let userProfile = ProfileModel(uid: uid, name: name, school: school, bio: bio, imageUrl: imageUrl, listPeopleILiked: iLiked, listPeopleLikedMe: likedMe)
                    completion(userProfile)
                } else {
                    completion(nil)
                }
            } else {
                print("Error getting profile: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func updateUserProfile(userProfile: ProfileModel) {
        let userRef = db.collection("users").document(userProfile.uid)
    
        // Convert the updated profile data to a dictionary
        let updatedData = userProfile.toDictionary()

        // Update the document in Firestore
        userRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating user profile: \(error.localizedDescription)")
            } else {
                print("User profile updated successfully!")
            }
        }
    }
    
    // Get all user except current user
    func getAllUsers(completion: @escaping ([ProfileModel]) -> Void) {
            let usersCollection = db.collection("users")

            usersCollection.getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                    completion([])
                } else {
                    // Parse the documents into user profiles
                    var userProfiles:[ProfileModel] = []
                    for doc in  snapshot!.documents {
                        let data = doc.data()
                        let name = data["name"] as? String ?? ""
                        let school = data["school"] as? String ?? ""
                        let bio = data["bio"] as? String ?? ""
                        let imageUrl = data["imageUrl"] as? String ?? ""
                        let uid = data["uid"] as? String ?? ""
                        let iLiked = data["listPeopleILiked"] as? [String] ?? []
                        let likedMe = data["listPeopleLikedMe"] as? [String] ?? []
                        if (uid != self.currentUser.uid) {
                            let profile = ProfileModel(uid: uid, name: name, school: school, bio: bio, imageUrl: imageUrl, listPeopleILiked: iLiked, listPeopleLikedMe: likedMe)
                            userProfiles.append(profile)
                        }
                    }
                    completion(userProfiles)
                }
            }
        }
}


