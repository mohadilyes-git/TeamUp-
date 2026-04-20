//
//  LoginView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 13/02/2026.
//



import SwiftUI
import Combine

struct LoginView: View {
    
    // Stores the email and password entered by the user
    @State private var email = ""
    @State private var password = ""
    @StateObject private var viewModel = AuthViewModel()
    
    // Tracks which background image is currently showing
    @State private var currentSlide = 0
    
    // Array of background images stored in Assets
    let slides = ["MainScreenPic1", "MainScreenPic2", "MainScreenPic3", "MainScreenPic4"]
    
    // Timer that fires every 3 seconds to change the background image
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        // If logged in successfully, go to HomeView
        if viewModel.isLoggedIn {
            MainTabView()
        } else {
            
            // NavigationStack allows navigation between screens
            NavigationStack {
                
                
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
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Subtitle
                        Text("Log in to find your roommate")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                        
                        // Input fields
                        VStack(spacing: 16) {
                            
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
                        }
                        .padding(.horizontal)
                        
                        // Shows error message if login fails
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .padding(.horizontal)
                        }
                        
                        // Login button  calls Firebase authentication
                        Button(action: {
                            viewModel.login(email: email, password: password)
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log In")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Link to registration screen
                        NavigationLink(destination: RegisterView()) {
                            Text("Don't have an account? ")
                                .foregroundColor(.white.opacity(0.8))
                            Text("Sign Up")
                                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                                .bold()
                        }
                        
                        Spacer()
                    }
                }
                // Advances the slide every time the timer fires
                .onReceive(timer) { _ in
                    currentSlide = (currentSlide + 1) % slides.count
                }
            }
        }
    }
}
