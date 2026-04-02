
//
//  MainTabView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 02/04/2026.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Cream background behind everything
            Color(hex: "FDF6EC").ignoresSafeArea()
            
            // Show the correct screen based on selected tab
            Group {
                if selectedTab == 0 {
                    
                } else if selectedTab == 1 {
                    
                } else if selectedTab == 2 {
                    
                } else {
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.horizontal, 20)
                .padding(.bottom, 26)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// Custom tab bar view
struct CustomTabBar: View {
    
    @Binding var selectedTab: Int
    
    let tabs: [(icon: String, selectedIcon: String, label: String)] = [
        ("house", "house.fill", "Browse"),
        ("heart", "heart.fill", "Matches"),
        ("book", "book.fill", "Guide"),
        ("gearshape", "gearshape.fill", "Settings")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                let tab = tabs[index]
                let isSelected = selectedTab == index
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                            .font(.system(size: 24))
                            .foregroundColor(isSelected ? .white : Color.gray.opacity(0.9))
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isSelected ? Color(red: 0.498, green: 0.467, blue: 0.867) : Color.clear)
                            .padding(.horizontal, 4)
                    )
                }
            }
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 6)
        .background(
            // white rounded pill background
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        )
    }
}

#Preview {
    MainTabView()
}
