//
//  MatchingViewModel.swift
//  TeamUp
//
//  Created by Ilyes Mo on 03/04/2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine
import UserNotifications



class MatchingViewModel: ObservableObject {
    
    @Published var profiles: [UserProfile] = []
    @Published var currentIndex = 0
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    // Load all profiles from Firestore except the current user
    
    func loadProfiles() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let db = Firestore.firestore()
        
        // First get all profiles the user has already swiped on
        db.collection("swipes").document(uid).collection("userSwipes").getDocuments { swipeSnapshot, _ in
            
            // Get UIDs of already swiped profiles
            let swipedUIDs = Set(swipeSnapshot?.documents.map { $0.documentID } ?? [])
            
            // Then load all profiles
            db.collection("profiles").getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                // Filter out current user AND already swiped profiles
                self.profiles = documents.compactMap { doc in
                    try? Firestore.Decoder().decode(UserProfile.self, from: doc.data())
                }.filter { $0.uid != uid && !swipedUIDs.contains($0.uid) }
                self.currentIndex = 0
            }
        }
    }
    
    // Calculate compatibility score between current user and another user
    
    func compatibilityScore(currentUser: UserProfile, otherUser: UserProfile) -> Int {
        var score = 0
        let maxScore = 110
        
        // Preferred area match - 20 points
        
        if currentUser.preferredArea == otherUser.preferredArea {
            score += 20
        }
        
        // Budget match within £200 - 15 points
        
        if abs(currentUser.budget - otherUser.budget) <= 200 {
            score += 15
        }
        
        // Sleep schedule match - 15 points
        
        if currentUser.sleepSchedule == otherUser.sleepSchedule {
            score += 15
        }
        
        // Cleanliness match within 1 point - 10 points
        
        if abs(currentUser.cleanliness - otherUser.cleanliness) <= 1 {
            score += 10
        }
        
        // Smoker match - 10 points
        
        if currentUser.isSmoker == otherUser.isSmoker {
            score += 10
        }
        
        // Pet friendly match - 10 points
        
        if currentUser.isPetFriendly == otherUser.isPetFriendly {
            score += 10
        }
        
        // Guest frequency match - 5 points
        
        if currentUser.guestFrequency == otherUser.guestFrequency {
            score += 5
        }
        
        // Noise tolerance match - 5 points
        
        if currentUser.noiseTolerance == otherUser.noiseTolerance {
            score += 5
        }
        
        // Home presence match - 5 points
        
        if currentUser.homePresence == otherUser.homePresence {
            score += 5
        }
        
        // Diet match - 5 points
        
        if currentUser.diet == otherUser.diet {
            score += 5
        }
        
        // Study schedule match - 5 points
        
        if currentUser.studySchedule == otherUser.studySchedule {
            score += 5
        }
        
        // Privacy level match - 3 points
        
        if currentUser.privacyLevel == otherUser.privacyLevel {
            score += 3
        }
        
        // Communication style match - 3 points
        
        if currentUser.communicationStyle == otherUser.communicationStyle {
            score += 3
        }
        
        // Shared hobbies - 2 points each up to max 10
        
        let sharedHobbies = currentUser.hobbies.filter { otherUser.hobbies.contains($0) }
        score += min(sharedHobbies.count * 2, 10)
        
        // Convert to percentage
        
        return Int((Double(score) / Double(maxScore)) * 100)
    }
    
    
    // Record a swipe in Firestore
    
    
    func swipe(direction: SwipeDirection, currentUser: UserProfile, swipedUser: UserProfile) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        
        // Save the swipe
        db.collection("swipes").document(uid).collection("userSwipes").document(swipedUser.uid).setData([
            "direction": direction.rawValue,
            "timestamp": Timestamp()
        ])
        
        // If swiped right check for mutual match
        
        if direction == .right {
            checkForMatch(currentUserUID: uid, swipedUserUID: swipedUser.uid, currentUser: currentUser, swipedUser: swipedUser)
        }
        
        // Move to next profile
        
        DispatchQueue.main.async {
            self.currentIndex += 1
        }
    }
    
    // Check if the other user also swiped right
    
    private func checkForMatch(currentUserUID: String, swipedUserUID: String, currentUser: UserProfile, swipedUser: UserProfile) {
        let db = Firestore.firestore()
        
        db.collection("swipes").document(swipedUserUID).collection("userSwipes").document(currentUserUID).getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let direction = data["direction"] as? String,
                  direction == "right" else { return }
            
            // It's a match! Save to matches collection
            let matchData: [String: Any] = [
                "users": [currentUserUID, swipedUserUID],
                "timestamp": Timestamp(),
                "compatibilityScore": self.compatibilityScore(currentUser: currentUser, otherUser: swipedUser)
            ]
            
            let matchID = ([currentUserUID, swipedUserUID].sorted()).joined(separator: "_")
            db.collection("matches").document(matchID).setData(matchData)
            
            // Send local notification
            DispatchQueue.main.async {
                self.sendMatchNotification(matchedUserName: swipedUser.name)
            }
            
        }
    }
    
    // Send local notification for new message
    func sendMessageNotification(senderName: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = senderName
        content.body = message
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Send local notification when a match is found
    func sendMatchNotification(matchedUserName: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Match! 🎉"
        content.body = "You and \(matchedUserName) liked each other!"
        content.sound = .default
        
        // Show immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    // Apply filters to profiles
    func applyFilters(_ filters: FilterOptions) -> [UserProfile] {
        return profiles.filter { profile in
            
            // Area filter
            if !filters.preferredArea.isEmpty && profile.preferredArea != filters.preferredArea {
                return false
            }
            
            // Budget filter
            if profile.budget < filters.minBudget || profile.budget > filters.maxBudget {
                return false
            }
            
            // Sleep schedule filter
            if !filters.sleepSchedule.isEmpty && profile.sleepSchedule != filters.sleepSchedule {
                return false
            }
            
            // smoking filter
            if filters.nonSmokersOnly && profile.isSmoker {
                return false
            }
            
            // Pet friendly filter
            if filters.petFriendlyOnly && !profile.isPetFriendly {
                return false
            }
            
            // Communication style filter
            if !filters.communicationStyle.isEmpty && profile.communicationStyle != filters.communicationStyle {
                return false
            }
            
            // Noise tolerance filter
            if !filters.noiseTolerance.isEmpty && profile.noiseTolerance != filters.noiseTolerance {
                return false
            }
            
            // Guest frequency filter
            if !filters.guestFrequency.isEmpty && profile.guestFrequency != filters.guestFrequency {
                return false
            }
            // Gender filter
            if !filters.genderPreference.isEmpty && profile.gender != filters.genderPreference {
                return false
            }
            return true
        }
    }
}
// Swipe direction enum

enum SwipeDirection: String {
    case left = "left"
    case right = "right"
}
