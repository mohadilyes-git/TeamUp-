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

// ProfileViewModel handles saving and loading the user profile
class ProfileViewModel: ObservableObject {
    
    @Published var profile = UserProfile()
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isSaved = false
    
    // Save the profile to Firestore
    func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        errorMessage = ""
        
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
        let db = Firestore.firestore()
        
        db.collection("profiles").document(uid).getDocument { snapshot, error in
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
