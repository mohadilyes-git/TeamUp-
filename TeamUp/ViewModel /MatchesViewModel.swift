//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 06/04/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

// Match model

struct Match: Identifiable {
    var id: String
    var uid: String
    var name: String
    var profileImageURL: String
    var compatibilityScore: Int
}

class MatchesViewModel: ObservableObject {
    
    @Published var matches: [Match] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // Load all matches for current user
    
    func loadMatches() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let db = Firestore.firestore()
        
        // Find all match documents that contain current user's uid
        db.collection("matches")
            .whereField("users", arrayContains: uid)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // For each match get the other user's profile
                let group = DispatchGroup()
                var loadedMatches: [Match] = []
                
                for doc in documents {
                    let data = doc.data()
                    guard let users = data["users"] as? [String],
                          let score = data["compatibilityScore"] as? Int else { continue }
                    
                    // Get the other user's uid
                    let otherUID = users.first { $0 != uid } ?? ""
                    
                    group.enter()
                    db.collection("profiles").document(otherUID).getDocument { profileSnapshot, _ in
                        if let profileData = profileSnapshot?.data(),
                           let profile = try? Firestore.Decoder().decode(UserProfile.self, from: profileData) {
                            let match = Match(
                                id: doc.documentID,
                                uid: otherUID,
                                name: profile.name,
                                profileImageURL: profile.profileImageURL,
                                compatibilityScore: score
                            )
                            loadedMatches.append(match)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.matches = loadedMatches.sorted { $0.compatibilityScore > $1.compatibilityScore }
                }
            }
    }
}
