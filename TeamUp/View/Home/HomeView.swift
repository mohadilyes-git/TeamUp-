//
//  HomeView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 26/02/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Light background colour
                Color(red: 0.949, green: 0.949, blue: 0.980)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    // App logo
                    Image("TeamUpmainlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    
                    // Welcome message
                    Text("Welcome to Teamup!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    
                    // Login status
                    Text("You are logged in ✅")
                        .foregroundColor(.gray)
                    
                    // Button to navigate to profile setup
                    NavigationLink(destination: ProfileSetupView(isEditMode: true)) {
                        Text("Set Up Profile")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
