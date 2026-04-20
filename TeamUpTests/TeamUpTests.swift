//
//  TeamUpTests.swift
//  TeamUp
//
//  Created by Ilyes Mo on 02/04/2026.
//

import XCTest
@testable import TeamUp

final class TeamUpTests: XCTestCase {
    
    var matchingVM: MatchingViewModel!
    
    override func setUp() {
        super.setUp()
        matchingVM = MatchingViewModel()
    }
    
    // UserProfile Default Values
    
    func testUserProfileDefaults() {
        let profile = UserProfile()
        XCTAssertEqual(profile.name, "")
        XCTAssertEqual(profile.age, 18)
        XCTAssertEqual(profile.gender, "")
        XCTAssertEqual(profile.budget, 500)
        XCTAssertEqual(profile.cleanliness, 3)
        XCTAssertFalse(profile.isSmoker)
        XCTAssertFalse(profile.isPetFriendly)
        XCTAssertEqual(profile.hobbies, [])
    }
    
    // Compatibility Score Tests
    
    func testIdenticalProfilesScoreMax() {
        var user = UserProfile()
        user.preferredArea = "Central London"
        user.budget = 800
        user.sleepSchedule = "Night owl"
        user.cleanliness = 4
        user.isSmoker = false
        user.isPetFriendly = true
        user.guestFrequency = "Rarely"
        user.noiseTolerance = "Low"
        user.homePresence = "Always home"
        user.diet = "Halal"
        user.studySchedule = "Night"
        user.privacyLevel = "Very private"
        user.communicationStyle = "Direct"
        user.hobbies = ["Gaming", "Gym", "Coding", "Music", "Football"]
        
        let score = matchingVM.compatibilityScore(currentUser: user, otherUser: user)
        XCTAssertEqual(score, 100, "Identical profiles should score 100%")
    }
    
    func testCompletelyDifferentProfilesScoreLow() {
        var a = UserProfile()
        a.preferredArea = "Central London"
        a.budget = 400
        a.sleepSchedule = "Early bird"
        a.cleanliness = 1
        a.isSmoker = true
        a.isPetFriendly = false
        a.guestFrequency = "Often"
        a.noiseTolerance = "High"
        a.homePresence = "Always home"
        a.diet = "Vegan"
        a.studySchedule = "Morning"
        a.privacyLevel = "Open"
        a.communicationStyle = "Direct"
        a.hobbies = ["Gaming"]
        
        var b = UserProfile()
        b.preferredArea = "Manchester"
        b.budget = 1500
        b.sleepSchedule = "Night owl"
        b.cleanliness = 5
        b.isSmoker = false
        b.isPetFriendly = true
        b.guestFrequency = "Rarely"
        b.noiseTolerance = "Low"
        b.homePresence = "Rarely home"
        b.diet = "Halal"
        b.studySchedule = "Night"
        b.privacyLevel = "Very private"
        b.communicationStyle = "Prefer texting"
        b.hobbies = ["Yoga"]
        
        let score = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        XCTAssertLessThan(score, 15, "Completely different profiles should score very low")
    }
    
    func testBudgetWithin200Matches() {
        var a = UserProfile()
        a.budget = 800
        var b = UserProfile()
        b.budget = 950
        let close = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.budget = 1200
        let far = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(close, far, "Budget within 200 should score higher")
    }
    
    func testCleanlinessWithin1Matches() {
        var a = UserProfile()
        a.cleanliness = 4
        var b = UserProfile()
        b.cleanliness = 5
        let close = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.cleanliness = 1
        let far = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(close, far, "Cleanliness within 1 should score higher")
    }
    
    func testSharedHobbiesIncreaseScore() {
        var a = UserProfile()
        a.hobbies = ["Gaming", "Gym", "Coding"]
        var b = UserProfile()
        b.hobbies = ["Gaming", "Gym", "Coding"]
        let shared = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.hobbies = ["Yoga", "Dancing"]
        let none = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(shared, none, "Shared hobbies should increase score")
    }
    
    func testHobbiesCappedAt10Points() {
        var a = UserProfile()
        a.hobbies = ["Gaming", "Gym", "Coding", "Music", "Football", "Tennis", "Reading"]
        var b = UserProfile()
        
        // 7 shared = 14 points but capped at 10
        b.hobbies = ["Gaming", "Gym", "Coding", "Music", "Football", "Tennis", "Reading"]
        let seven = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        // 5 shared = 10 points exactly at cap
        b.hobbies = ["Gaming", "Gym", "Coding", "Music", "Football"]
        let five = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertEqual(seven, five, "Hobbies should cap at 10 points")
    }
    
    func testSameAreaScoresHigher() {
        var a = UserProfile()
        a.preferredArea = "Central London"
        var b = UserProfile()
        b.preferredArea = "Central London"
        let same = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.preferredArea = "Manchester"
        let diff = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(same, diff, "Same area should score higher")
    }
    
    func testSmokerMismatchReducesScore() {
        var a = UserProfile()
        a.isSmoker = false
        var b = UserProfile()
        b.isSmoker = false
        let match = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.isSmoker = true
        let mismatch = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(match, mismatch, "Smoker mismatch should reduce score")
    }
    
    func testScoreNeverNegativeOrOver100() {
        let a = UserProfile()
        let b = UserProfile()
        let score = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        XCTAssertGreaterThanOrEqual(score, 0, "Score should not be negative")
        XCTAssertLessThanOrEqual(score, 100, "Score should not exceed 100")
    }
    
    func testSleepScheduleMatch() {
        var a = UserProfile()
        a.sleepSchedule = "Night owl"
        var b = UserProfile()
        b.sleepSchedule = "Night owl"
        let same = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        b.sleepSchedule = "Early bird"
        let diff = matchingVM.compatibilityScore(currentUser: a, otherUser: b)
        
        XCTAssertGreaterThan(same, diff, "Same sleep schedule should score higher")
    }
    
    //  Filter Tests
    
    func testFilterByArea() {
        var p1 = UserProfile(); p1.uid = "1"; p1.preferredArea = "Central London"
        var p2 = UserProfile(); p2.uid = "2"; p2.preferredArea = "Manchester"
        var p3 = UserProfile(); p3.uid = "3"; p3.preferredArea = "Central London"
        matchingVM.profiles = [p1, p2, p3]
        
        var filters = FilterOptions()
        filters.preferredArea = "Central London"
        let results = matchingVM.applyFilters(filters)
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.preferredArea == "Central London" })
    }
    
    func testFilterByBudget() {
        var p1 = UserProfile(); p1.uid = "1"; p1.budget = 600
        var p2 = UserProfile(); p2.uid = "2"; p2.budget = 900
        var p3 = UserProfile(); p3.uid = "3"; p3.budget = 1500
        matchingVM.profiles = [p1, p2, p3]
        
        var filters = FilterOptions()
        filters.minBudget = 500
        filters.maxBudget = 1000
        let results = matchingVM.applyFilters(filters)
        
        XCTAssertEqual(results.count, 2)
    }
    
    func testFilterNonSmokers() {
        var p1 = UserProfile(); p1.uid = "1"; p1.isSmoker = false
        var p2 = UserProfile(); p2.uid = "2"; p2.isSmoker = true
        matchingVM.profiles = [p1, p2]
        
        var filters = FilterOptions()
        filters.nonSmokersOnly = true
        let results = matchingVM.applyFilters(filters)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertFalse(results[0].isSmoker)
    }
    
    func testFilterMultipleCriteria() {
        var p1 = UserProfile(); p1.uid = "1"; p1.preferredArea = "Central London"; p1.isSmoker = false
        var p2 = UserProfile(); p2.uid = "2"; p2.preferredArea = "Central London"; p2.isSmoker = true
        var p3 = UserProfile(); p3.uid = "3"; p3.preferredArea = "Manchester"; p3.isSmoker = false
        matchingVM.profiles = [p1, p2, p3]
        
        var filters = FilterOptions()
        filters.preferredArea = "Central London"
        filters.nonSmokersOnly = true
        let results = matchingVM.applyFilters(filters)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results[0].uid, "1")
    }
    
    func testEmptyFiltersReturnsAll() {
        var p1 = UserProfile(); p1.uid = "1"
        var p2 = UserProfile(); p2.uid = "2"
        var p3 = UserProfile(); p3.uid = "3"
        matchingVM.profiles = [p1, p2, p3]
        
        let results = matchingVM.applyFilters(FilterOptions())
        XCTAssertEqual(results.count, 3)
    }
    
    func testFilterPetFriendly() {
        var p1 = UserProfile(); p1.uid = "1"; p1.isPetFriendly = true
        var p2 = UserProfile(); p2.uid = "2"; p2.isPetFriendly = false
        matchingVM.profiles = [p1, p2]
        
        var filters = FilterOptions()
        filters.petFriendlyOnly = true
        let results = matchingVM.applyFilters(filters)
        
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results[0].isPetFriendly)
    }
    
    //  Match ID Tests
    
    func testMatchIDDeterministic() {
        let id1 = (["abc", "xyz"].sorted()).joined(separator: "_")
        let id2 = (["xyz", "abc"].sorted()).joined(separator: "_")
        XCTAssertEqual(id1, id2, "Match ID should be same regardless of order")
        XCTAssertEqual(id1, "abc_xyz")
    }
    
    // SwipeDirection Tests
    
    func testSwipeDirectionValues() {
        XCTAssertEqual(SwipeDirection.left.rawValue, "left")
        XCTAssertEqual(SwipeDirection.right.rawValue, "right")
    }
}
