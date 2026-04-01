//
//  ProfileViewModel.swift
//  TeamUp
//
//  Created by Ilyes Mo on 31/03/2026.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// ProfileViewModel handles saving and loading the user profile
class ProfileViewModel: ObservableObject {
    
    @Published var profile = UserProfile()
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isSaved = false
    @Published var selectedImage: UIImage? = nil
    
    // Save profile photo to Firebase Storage and get the download URL
    func uploadProfileImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        // Compress the image to reduce file size
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        // Create a reference to Firebase Storage
        let storageRef = Storage.storage().reference()
        
        // Store the image at profileImages/uid.jpg
        let profileImageRef = storageRef.child("profileImages/\(uid).jpg")
        
        // Upload the image data
        profileImageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(nil)
                return
            }
            
            // Get the download URL after upload
            profileImageRef.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(nil)
                    return
                }
                // Return the URL as a string
                completion(url?.absoluteString)
            }
        }
    }
    
    // Save the full profile to Firestore
    func saveProfile(image: UIImage? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        
        // If there's a profile image, upload it first then save profile
        if let image = image {
            uploadProfileImage(image) { url in
                if let url = url {
                    // Store the image URL in the profile
                    self.profile.profileImageURL = url
                }
                // Save profile to Firestore after image upload
                self.saveToFirestore(uid: uid)
            }
        } else {
            // No image, just save profile directly
            saveToFirestore(uid: uid)
        }
    }
    
    // Save profile data to Firestore
    private func saveToFirestore(uid: String) {
        var data = profile
        data.uid = uid
        
        let db = Firestore.firestore()
        
        do {
            let encoded = try Firestore.Encoder().encode(data)
            db.collection("profiles").document(uid).setData(encoded) { error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.isSaved = true
            }
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Load the profile from Firestore
    func loadProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let db = Firestore.firestore()
        db.collection("profiles").document(uid).getDocument { snapshot, error in
            self.isLoading = false
            if let data = snapshot?.data() {
                do {
                    let profile = try Firestore.Decoder().decode(UserProfile.self, from: data)
                    DispatchQueue.main.async {
                        self.profile = profile
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
