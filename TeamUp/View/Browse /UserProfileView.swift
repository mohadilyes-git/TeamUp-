//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 12/04/2026.
//

import SwiftUI

struct UserProfileView: View {
    
    let profile: UserProfile
    let score: Int
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6EC").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Profile image
                    
                    ZStack(alignment: .bottom) {
                        if !profile.profileImageURL.isEmpty {
                            AsyncImage(url: URL(string: profile.profileImageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 380)
                                    .clipped()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 380)
                            }
                        } else {
                            ZStack {
                                Color.gray.opacity(0.2)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 380)
                        }
                        
                        // Gradient overlay
                        
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.7)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .frame(height: 200)
                        
                        // Name and basic info
                        
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(profile.name), \(profile.age)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                Text(profile.university)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                Text(profile.preferredArea)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            
                            // Compatibility score
                            
                            VStack(spacing: 2) {
                                Text("\(score)%")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Text("match")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(12)
                            .background(Circle().fill(scoreColor(score: score)))
                        }
                        .padding(20)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Bio
                        
                        if !profile.bio.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                SectionHeader(title: "About")
                                Text(profile.bio)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Course info
                        
                        InfoCard(items: [
                            ("graduationcap.fill", profile.course),
                            ("mappin.circle.fill", profile.preferredArea),
                            ("calendar", formatDate(profile.moveInDate))
                        ])
                        
                        // Budget
                        
                        VStack(alignment: .leading, spacing: 8) {
                            SectionHeader(title: "Budget")
                            Text("£\(profile.budget) / month")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        }
                        
                        // Lifestyle
                        
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Lifestyle")
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                LifestyleTag(icon: "moon.fill", text: profile.sleepSchedule)
                                LifestyleTag(icon: "person.2.fill", text: profile.guestFrequency + " guests")
                                LifestyleTag(icon: "speaker.wave.2.fill", text: profile.noiseTolerance + " noise")
                                LifestyleTag(icon: "house.fill", text: profile.homePresence)
                                if profile.isSmoker {
                                    LifestyleTag(icon: "smoke.fill", text: "Smoker")
                                } else {
                                    LifestyleTag(icon: "nosign", text: "Non-smoker")
                                }
                                if profile.isPetFriendly {
                                    LifestyleTag(icon: "pawprint.fill", text: "Pet friendly")
                                } else {
                                    LifestyleTag(icon: "nosign", text: "No pets")
                                }
                                if !profile.diet.isEmpty && profile.diet != "No preference" {
                                    LifestyleTag(icon: "fork.knife", text: profile.diet)
                                }
                                if !profile.sleepSchedule.isEmpty {
                                    LifestyleTag(icon: "book.fill", text: profile.studySchedule)
                                }
                            }
                        }
                        
                        // Hobbies
                        
                        if !profile.hobbies.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "Interests")
                                FlowLayout(items: profile.hobbies)
                            }
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(20)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func scoreColor(score: Int) -> Color {
        if score >= 70 { return Color.green.opacity(0.8) }
        else if score >= 40 { return Color.orange.opacity(0.8) }
        else { return Color.red.opacity(0.8) }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Move in: \(formatter.string(from: date))"
    }
}

// Section header

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
    }
}

// Info card with icons
struct InfoCard: View {
    let items: [(String, String)]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items, id: \.0) { item in
                if !item.1.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: item.0)
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .frame(width: 24)
                        Text(item.1)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
    }
}

// Lifestyle tag
struct LifestyleTag: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

// Flow layout for hobbies

struct FlowLayout: View {
    let items: [String]
    
    var body: some View {
        var rows: [[String]] = [[]]
        var currentRowWidth: CGFloat = 0
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 40
        
        for item in items {
            let itemWidth = CGFloat(item.count * 9 + 24)
            if currentRowWidth + itemWidth > maxWidth {
                rows.append([item])
                currentRowWidth = itemWidth
            } else {
                rows[rows.count - 1].append(item)
                currentRowWidth += itemWidth + 8
            }
        }
        
        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(rows[rowIndex], id: \.self) { item in
                        Text(item)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "EEEDFE"))
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}


