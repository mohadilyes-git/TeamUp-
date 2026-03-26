//
//  TeamUpApp.swift
//  TeamUp
//
//  Created by Ilyes Mo on 18/03/2026.
//

import SwiftUI
import Firebase

@main
struct TeamUpApp: App {
    
    // Configure Firebase when the app launches
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
