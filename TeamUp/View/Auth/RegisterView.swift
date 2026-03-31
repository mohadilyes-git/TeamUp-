//
//  Untitled 2.swift
//  TeamUp
//
//  Created by Ilyes Mo on 19/03/2026.
//

import SwiftUI

import SwiftUI

struct RegisterView: View {
    
    // Stores the user's name, email and password
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        if viewModel.isLoggedIn {
            HomeView()
        } else {
            
            // ZStack places background colour behind all content
            ZStack {
                
                // Light background colour
                Color(red: 0.949, green: 0.949, blue: 0.980)
                    .ignoresSafeArea()
                
                // Main vertical layout
                VStack(spacing: 24) {
                    
                    Spacer()
                    
                    // App logo
                    Image("TeamUpmainlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                    
                    // Main heading
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    
                    // Subtitle
                    Text("Join Teamup today")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    // Input fields
                    VStack(spacing: 16) {
                        
                        // Full name input field
                        TextField("Full Name", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        
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
                        
                        // Confirm password field checks passwords match
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                    }
                    // Register button Firebase logic will be added here
                    Button(action: {
                        guard password == confirmPassword else {
                            viewModel.errorMessage = "Passwords do not match"
                            return
                        }
                        viewModel.register(name: name, email: email, password: password)
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign Up")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            }
                        }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .cornerRadius(12)
                        
                            .padding(.horizontal)
                        
                        // Link back to login screen
                        NavigationLink(destination: LoginView()) {
                            Text("Already have an account? ")
                                .foregroundColor(.gray)
                            Text("Log In")
                                .foregroundColor(
                                    Color(red: 0.498, green: 0.467, blue: 0.867))
                                .bold()
                        }
                        
                        Spacer()
                    }
                }
            }// closes Zstack
        } // closes else
    }// closes body

