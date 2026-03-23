//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 18/03/2026.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            LoginView()
        } else {
            ZStack {
                Color(red: 0.498, green: 0.467, blue: 0.867)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    Image("TeamUpmainlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.white)
                    Text("Teamup")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    Text("Find your perfect roommate")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                }
            }
            
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
