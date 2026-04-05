//
//  BrowseView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 03/04/2026.
//


import SwiftUI
import FirebaseAuth

struct BrowseView: View {
    
    @StateObject private var matchingVM = MatchingViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6EC").ignoresSafeArea()
                
                if matchingVM.isLoading {
                    ProgressView()
                        .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                } else if matchingVM.currentIndex >= matchingVM.profiles.count {
                    // No more profiles
                    VStack(spacing: 16) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        Text("No more profiles!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        Text("Check back later for new roommates")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                        Button(action: {
                            matchingVM.currentIndex = 0
                            matchingVM.loadProfiles()
                        }) {
                            Text("Refresh")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    VStack(spacing: 20) {
                        // Card stack
                        ZStack {
                            // Show next card behind current
                            if matchingVM.currentIndex + 1 < matchingVM.profiles.count {
                                ProfileCardView(
                                    profile: matchingVM.profiles[matchingVM.currentIndex + 1],
                                    score: matchingVM.compatibilityScore(
                                        currentUser: profileVM.profile,
                                        otherUser: matchingVM.profiles[matchingVM.currentIndex + 1]
                                    )
                                )
                                .scaleEffect(0.95)
                                .offset(y: 10)
                            }
                            
                            // Current card
                            SwipeableCardView(
                                profile: matchingVM.profiles[matchingVM.currentIndex],
                                score: matchingVM.compatibilityScore(
                                    currentUser: profileVM.profile,
                                    otherUser: matchingVM.profiles[matchingVM.currentIndex]
                                ),
                                onSwipe: { direction in
                                    matchingVM.swipe(
                                        direction: direction,
                                        currentUser: profileVM.profile,
                                        swipedUser: matchingVM.profiles[matchingVM.currentIndex]
                                    )
                                }
                            )
                        }
                        .padding(.horizontal)
                        
                        // Action buttons
                        HStack(spacing: 40) {
                            // Dislike button
                            Button(action: {
                                matchingVM.swipe(
                                    direction: .left,
                                    currentUser: profileVM.profile,
                                    swipedUser: matchingVM.profiles[matchingVM.currentIndex]
                                )
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.red)
                                    .frame(width: 70, height: 70)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 8)
                            }
                            
                            // Like button
                            Button(action: {
                                matchingVM.swipe(
                                    direction: .right,
                                    currentUser: profileVM.profile,
                                    swipedUser: matchingVM.profiles[matchingVM.currentIndex]
                                )
                            }) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.white)
                                    .frame(width: 70, height: 70)
                                    .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 8)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                matchingVM.loadProfiles()
                profileVM.loadProfile()
            }
        }
    }
}

// Profile Card View


struct ProfileCardView: View {
    let profile: UserProfile
    let score: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Profile image
            if !profile.profileImageURL.isEmpty {
                AsyncImage(url: URL(string: profile.profileImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 520)
                .clipped()
            } else {
                // Placeholder if no image
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 520)
            }
            
            // Gradient overlay at bottom
            LinearGradient(
                colors: [.clear, .black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(height: 280)
            
            // Profile info at bottom
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(profile.name), \(profile.age)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        Text(profile.university)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        Text(profile.preferredArea)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    
                    // Compatibility score badge
                    VStack(spacing: 2) {
                        Text("\(score)%")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        Text("match")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(12)
                    .background(
                        Circle()
                            .fill(scoreColor(score: score))
                    )
                }
            }
            .padding(20)
        }
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 10)
    }
    
    // Color based on compatibility score
    func scoreColor(score: Int) -> Color {
        if score >= 70 {
            return Color.green.opacity(0.8)
        } else if score >= 40 {
            return Color.orange.opacity(0.8)
        } else {
            return Color.red.opacity(0.8)
        }
    }
}

//  Swipeable Card View
struct SwipeableCardView: View {
    let profile: UserProfile
    let score: Int
    let onSwipe: (SwipeDirection) -> Void
    
    @State private var offset = CGSize.zero
    @State private var rotation: Double = 0
    
    var body: some View {
        ProfileCardView(profile: profile, score: score)
            .offset(x: offset.width, y: offset.height)
            .rotationEffect(.degrees(rotation))
            .overlay(
                // Like overlay
                ZStack {
                    if offset.width > 50 {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.green, lineWidth: 4)
                            .overlay(
                                Text("LIKE")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.green)
                                    .rotationEffect(.degrees(-20))
                                    .padding()
                                , alignment: .topLeading
                            )
                            .opacity(Double(offset.width / 100))
                    }
                    
                    if offset.width < -50 {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red, lineWidth: 4)
                            .overlay(
                                Text("SKIP")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.red)
                                    .rotationEffect(.degrees(20))
                                    .padding()
                                , alignment: .topTrailing
                            )
                            .opacity(Double(-offset.width / 100))
                    }
                }
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                        rotation = Double(gesture.translation.width / 20)
                    }
                    .onEnded { gesture in
                        if gesture.translation.width > 120 {
                            // Swiped right
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = CGSize(width: 500, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSwipe(.right)
                                offset = .zero
                                rotation = 0
                            }
                        } else if gesture.translation.width < -120 {
                            // Swiped left
                            withAnimation(.easeOut(duration: 0.3)) {
                                offset = CGSize(width: -500, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onSwipe(.left)
                                offset = .zero
                                rotation = 0
                            }
                        } else {
                            // Snap back
                            withAnimation(.spring()) {
                                offset = .zero
                                rotation = 0
                            }
                        }
                    }
            )
    }
}
#Preview {
    BrowseView()
}
