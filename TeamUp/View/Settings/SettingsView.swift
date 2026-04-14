//
//  SettingsView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 05/04/2026.
//

//
//  SettingsView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 03/04/2026.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct SettingsView: View {
    
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6EC").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Profile header
                        VStack(spacing: 12) {
                            if !profileVM.profile.profileImageURL.isEmpty {
                                KFImage(URL(string: profileVM.profile.profileImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                    )
                            }
                            
                            Text(profileVM.profile.name)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            
                            Text(profileVM.profile.university)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top)
                        
                        // Settings options
                        VStack(spacing: 0) {
                            
                            // Edit profile
                            NavigationLink(destination: ProfileSetupView(isEditMode: true)) {
                                SettingsRowView(
                                    icon: "person.fill",
                                    title: "Edit Profile",
                                    color: Color(red: 0.498, green: 0.467, blue: 0.867)
                                )
                            }
                            
                            Divider().padding(.leading, 56)
                            
                            // Notifications
                            SettingsRowView(
                                icon: "bell.fill",
                                title: "Notifications",
                                color: .orange
                            )
                            
                            Divider().padding(.leading, 56)
                            
                            // Privacy
                            SettingsRowView(
                                icon: "lock.fill",
                                title: "Privacy",
                                color: .blue
                            )
                            
                            Divider().padding(.leading, 56)
                            
                            // Help
                            SettingsRowView(
                                icon: "questionmark.circle.fill",
                                title: "Help & Support",
                                color: .green
                            )
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Sign out button
                        Button(action: {
                            showSignOutAlert = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                        
                        Text("TeamUp v1.0")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Settings")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .fixedSize()
                }
            }
            .onAppear {
                profileVM.loadProfile()
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    authVM.logout()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

// Reusable settings row
struct SettingsRowView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(color)
                .cornerRadius(8)
            
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
