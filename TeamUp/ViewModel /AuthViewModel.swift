//
//  AuthViewModel.swift
//  TeamUp
//
//  Created by Ilyes Mo on 23/03/2026.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

// AuthViewModel handles all authentication logic
// Conforms to ObservableObject so views can watch for changes
class AuthViewModel: ObservableObject {
    
    // @Published variables automatically update any watching views
    @Published var isLoggedIn = false
    @Published var errorMessage = ""
    @Published var isLoading = false
    
    // Register a new user with email and password
    func v(name: String, email: String, password: String) {
        isLoading = true
        errorMessage = ""
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isLoggedIn = true
        }
    }
    
    // Log in an existing user
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.isLoggedIn = true
        }
        
            self.isLoggedIn = true
        }
    }
    
    // Log out the current user
    func logout() {
        try? Auth.auth().signOut()
        isLoggedIn = false
    }
}
