//
//  ContentView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 18/03/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSplash = true
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView()
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
}

#Preview {
    ContentView()
}
