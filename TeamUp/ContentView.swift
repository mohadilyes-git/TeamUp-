//
//  ContentView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 18/03/2026.
//

import SwiftUI




struct ContentView: View {
    @State private var showSplash = true
    
    // Watch the AuthViewModel to know if user is logged in
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isLoggedIn {
            MainTabView()
                .environmentObject(authViewModel)
        } else if showSplash {
            SplashScreenView()
                .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
