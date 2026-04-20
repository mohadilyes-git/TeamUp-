//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 06/03/2026.
//
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Kingfisher


struct MatchesView: View {
    
    @StateObject private var viewModel = MatchesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6EC").ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                } else if viewModel.matches.isEmpty {
                    // No matches yet
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        Text("No matches yet!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        Text("Keep swiping to find your perfect roommate")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.matches) { match in
                                NavigationLink(destination: ChatView(match: match)) {
                                    MatchRowView(match: match)
                                }
                                Divider().padding(.leading, 80)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Matches")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .fixedSize()
                }
            }
            .onAppear {
                viewModel.loadMatches()
            }
        }
    }
}

// Single match row
struct MatchRowView: View {
    let match: Match
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile image
            if !match.profileImageURL.isEmpty {
                KFImage(URL(string: match.profileImageURL))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }
            
            // Name and compatibility
            VStack(alignment: .leading, spacing: 4) {
                Text(match.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text("\(match.compatibilityScore)% compatibility")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
            }
            
            Spacer()
            
            if match.unreadCount > 0 {
                // Red badge with unread count
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 22, height: 22)
                    Text("\(match.unreadCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding()
    }
}

#Preview {
    MatchesView()
}
