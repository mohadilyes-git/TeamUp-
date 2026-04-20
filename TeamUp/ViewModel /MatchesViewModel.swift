//
//  Untitled.swift
//  TeamUp
//
//  Created by Ilyes Mo on 05/03/2026.
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
        
        // Fetch all match documents that contain the current user's uid
        db.collection("matches")
            .whereField("users", arrayContains: uid)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Use DispatchGroup to wait for all async profile fetches to complete
                let group = DispatchGroup()
                var loadedMatches: [Match] = []
                
                for doc in documents {
                    let data = doc.data()
                    guard let users = data["users"] as? [String],
                          let score = data["compatibilityScore"] as? Int else { continue }
                    
                    // Get the other user's uid by filtering out the current user
                    let otherUID = users.first { $0 != uid } ?? ""
                    
                    group.enter()
                    // Fetch the matched user's profile from Firestore
                    db.collection("profiles").document(otherUID).getDocument { profileSnapshot, _ in
                        if let profileData = profileSnapshot?.data(),
                           let profile = try? Firestore.Decoder().decode(UserProfile.self, from: profileData) {
                            
                            // Generate consistent chat ID using sorted UIDs
                            let chatID = ([uid, otherUID].sorted()).joined(separator: "_")
                            
                            // Real-time listener for unread messages from the other user
                            db.collection("chats").document(chatID).collection("messages")
                                .whereField("senderUID", isEqualTo: otherUID)
                                .whereField("isRead", isEqualTo: false)
                                .addSnapshotListener { msgSnapshot, error in
                                    if let error = error {
                                        print("Unread error: \(error.localizedDescription)")
                                    }
                                    // Count unread messages from the other user
                                    let unreadCount = msgSnapshot?.documents.count ?? 0
                                    print("Unread count for \(profile.name): \(unreadCount)")
                                    
                                    // Create match object with latest unread count
                                    let match = Match(
                                        id: doc.documentID,
                                        uid: otherUID,
                                        name: profile.name,
                                        profileImageURL: profile.profileImageURL,
                                        compatibilityScore: score,
                                        unreadCount: unreadCount
                                    )
                                    
                                    // Update match on main thread  update existing or add new
                                    DispatchQueue.main.async {
                                        if let index = self.matches.firstIndex(where: { $0.uid == otherUID }) {
                                            // Update existing match with new unread count
                                            self.matches[index] = match
                                        } else {
                                            // Add new match and sort by compatibility score
                                            self.matches.append(match)
                                            self.matches.sort { $0.compatibilityScore > $1.compatibilityScore }
                                        }
                                    }
                                }
                            group.leave()
                        } else {
                            // Leave group even if profile fetch fails to avoid deadlock
                            group.leave()
                        }
                    }
                }
                
                // Group notify is empty as matches are updated individually by the snapshot listener
                group.notify(queue: .main) {
                    // Already handled by snapshot listener above
                }
            }
    }
}
