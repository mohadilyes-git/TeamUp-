//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 06/04/2026.
//


import SwiftUI

struct ChatView: View {
    let match: Match
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6EC").ignoresSafeArea()
            Text("Chat with \(match.name)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
        }
        .navigationTitle(match.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

