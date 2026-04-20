//
//  ContentView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 15/02/2026.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    
    @State private var showSplash = true
    @StateObject private var authViewModel = AuthViewModel()
    
    
    @State private var hasProfile: Bool? = nil
    
    var body: some View {
        Group {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }
            } else if authViewModel.isLoggedIn {
                if let hasProfile = hasProfile {
                    if hasProfile {
                        // Existing user with profile - go to main app
                        MainTabView()
                    } else {
                        // New user without profile - go to profile setup
                        ProfileSetupView()
                            .navigationBarBackButtonHidden(true)
                    }
                } else {
                    // Still checking Firestore
                    ProgressView()
                        .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .onAppear {
                            checkUserProfile()
                        }
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: authViewModel.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                checkUserProfile()
            } else {
                hasProfile = nil
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("profileSaved"))) { _ in
            hasProfile = true
        }
    }
    
    // Check if user has a profile in Firestore
    func checkUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("profiles").document(uid).getDocument { snapshot, _ in
            DispatchQueue.main.async {
                if let data = snapshot?.data(), !data.isEmpty {
                    hasProfile = true
                } else {
                    hasProfile = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
