//
//  ContentView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 18/03/2026.
//

import SwiftUI

struct ContentView: View {
    
    // Watch the AuthViewModel to know if user is logged in
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isLoggedIn {
            // User already logged in  go straight to HomeView
            MainTabView()
        } else {
            // User not logged in  show splash then login
            SplashScreenView()
        }
    }
}

#Preview {
    ContentView()
}
