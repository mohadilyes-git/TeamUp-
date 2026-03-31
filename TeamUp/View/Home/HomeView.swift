//
//  Home.swift
//  TeamUp
//
//  Created by Ilyes Mo on 28/03/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(red: 0.949, green: 0.949, blue: 0.980)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Image("TeamUpmainlogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                Text("Welcome to Teamup!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                Text("You are logged in ✅")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    HomeView()
}
