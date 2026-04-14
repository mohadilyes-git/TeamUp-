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
    var unreadCount: Int = 0
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
        
        db.collection("matches")
            .whereField("users", arrayContains: uid)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                let group = DispatchGroup()
                var loadedMatches: [Match] = []
                
                for doc in documents {
                    let data = doc.data()
                    guard let users = data["users"] as? [String],
                          let score = data["compatibilityScore"] as? Int else { continue }
                    
                    let otherUID = users.first { $0 != uid } ?? ""
                    
                    group.enter()
                    db.collection("profiles").document(otherUID).getDocument { profileSnapshot, _ in
                        if let profileData = profileSnapshot?.data(),
                           let profile = try? Firestore.Decoder().decode(UserProfile.self, from: profileData) {
                            
                            let chatID = ([uid, otherUID].sorted()).joined(separator: "_")
                            db.collection("chats").document(chatID).collection("messages")
                                .whereField("senderUID", isEqualTo: otherUID)
                                .whereField("isRead", isEqualTo: false)
                                .getDocuments { msgSnapshot, error in
                                    if let error = error {
                                        print("Unread error: \(error.localizedDescription)")
                                    }
                                    let unreadCount = msgSnapshot?.documents.count ?? 0
                                    print("Unread count for \(profile.name): \(unreadCount)")
                                    
                                    // Use unreadCount when creating Match
                                    let match = Match(
                                        id: doc.documentID,
                                        uid: otherUID,
                                        name: profile.name,
                                        profileImageURL: profile.profileImageURL,
                                        compatibilityScore: score,
                                        unreadCount: unreadCount
                                    )
                                    loadedMatches.append(match)
                                    group.leave()
                                }
                        } else {
                            group.leave()
                        }
                    }
                }
                
                // Outside the for loop
                group.notify(queue: .main) {
                    self.matches = loadedMatches.sorted { $0.compatibilityScore > $1.compatibilityScore }
                }
            }
    }
}
