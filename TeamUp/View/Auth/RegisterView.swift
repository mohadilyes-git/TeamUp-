//
//  RegisterView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 19/03/2026.
//


import SwiftUI
import Combine

struct RegisterView: View {
    
    // Stores the user's name, email and password
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @StateObject private var viewModel = AuthViewModel()
    
    // Tracks which background image is currently showing
    @State private var currentSlide = 0
    
    // Array of background images stored in Assets
    let slides = ["MainScreenPic1", "MainScreenPic2", "MainScreenPic3", "MainScreenPic4"]
    
    // Timer that fires every 3 seconds to change the background image
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        // If registered successfully, go to HomeView
        if viewModel.isLoggedIn {
            NavigationStack {
                    ProfileSetupView()
                }
        } else {
            
           
            ZStack {
                
                // Background slideshow image
                Image(slides[currentSlide])
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 1), value: currentSlide)
                
                // Dark overlay so text is readable over the photos
                
                Color.black.opacity(0.5)
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
                        .foregroundColor(.white)
                    
                    // Subtitle
                    Text("Join Teamup today")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Input fields
                    VStack(spacing: 16) {
                        
                        // Full name input field
                        TextField("Full Name", text: $name)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                        
                        // Email input field
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                        
                        // Password input field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                        
                        // Confirm password field checks passwords match
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    
                    // Shows error message if registration fails
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.horizontal)
                    }
                    
                    // Register button validates passwords then calls Firebase
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
                            .foregroundColor(.white.opacity(0.8))
                        Text("Log In")
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .bold()
                    }
                    
                    Spacer()
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 1)) {
                        currentSlide = (currentSlide + 1) % slides.count
                    }
                }
            }
        }
    }
}
