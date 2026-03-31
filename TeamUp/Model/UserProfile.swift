//
//  UserProfile.swift
//  TeamUp
//
//  Created by Ilyes Mo on 31/03/2026.
//

import Foundation

// UserProfile model stores all the information about a user
struct UserProfile: Codable {
    
    // Personal
    var uid: String = ""
    var name: String = ""
    var age: Int = 18
    var gender: String = ""
    var university: String = ""
    var course: String = ""
    var bio: String = ""
    var profileImageURL: String = ""
    
    // Housing preferences
    var budget: Int = 500
    var preferredArea: String = ""
    var moveInDate: String = ""
    var preferredGender: String = ""
    
    // Lifestyle
    var cleanliness: Int = 3
    var sleepSchedule: String = ""
    var isSmoker: Bool = false
    var isPetFriendly: Bool = false
    var guestFrequency: String = ""
    var noiseTolerance: String = ""
    var homePresence: String = ""
    var diet: String = ""
    
    // Interests
    var hobbies: [String] = []
}
