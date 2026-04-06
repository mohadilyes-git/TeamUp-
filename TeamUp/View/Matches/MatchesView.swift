//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 06/04/2026.
//
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
            .navigationTitle("Matches")
            .navigationBarTitleDisplayMode(.large)
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
                AsyncImage(url: URL(string: match.profileImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        )
                }
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
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
    }
}

#Preview {
    MatchesView()
}
