//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 20/03/2026.
//

import SwiftUI

struct LoginView: View {
    
    // Stores the email and password entered by the user
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var goToRegister = false
    
    var body: some View {
        
        // NavigationStack allows navigation between screens
        
        NavigationStack {
            
            // ZStack places background colour behind all content
            
            ZStack {
                Color(red: 0.949, green: 0.949, blue: 0.980)
                    .ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                    // Logo
                    Image("TeamUpmainlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    Text("Welcome Back")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    Text("Log in to find your roommate")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    // Input fields
                    VStack(spacing: 16) {
                        
                        // Email input field
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .autocapitalization(.none)
                        
                        // Password input field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                        // Login Button
                    Button(action: {
                        // Firebase login will go here
                    }) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    // Register link
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account? ")
                            .foregroundColor(.gray)
                        Text("Sign Up")
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .bold()
                    }
                    Spacer()
                }
            }
        }
    }
}
