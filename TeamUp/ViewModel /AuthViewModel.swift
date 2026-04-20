//
//  AuthViewModel.swift
//  TeamUp
//
//  Created by Ilyes Mo on 16/02/2026.
//


import Foundation
import Combine
import Firebase
import FirebaseAuth
import FirebaseFirestore

// AuthViewModel handles all authentication logic
class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    init() {
        // Firebase listens to auth state in real time
        // This fires on ALL instances when auth changes
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                self.isLoggedIn = user != nil
            }
        }
    }
    
    // Register a new user with email and password
    func register(name: String, email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let uid = result?.user.uid else { return }
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "name": name,
                "email": email,
                "uid": uid,
                "createdAt": Timestamp()
            ]) { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Log in an existing user
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    // Log out the current user
    func logout() {
        try? Auth.auth().signOut()
    }
}
