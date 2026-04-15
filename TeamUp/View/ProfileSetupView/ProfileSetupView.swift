//
//  ProfileSetupView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 01/04/2026.
//

import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseFirestore
import Kingfisher

struct ProfileSetupView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @State private var currentStep = 1
    @State private var navigateToHome = false
    @Environment(\.dismiss) var dismiss
    var isEditMode: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6EC")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ProgressBarView(currentStep: currentStep, totalSteps: 4)
                    .padding(.horizontal)
                    .padding(.top)
                
                if currentStep == 1 {
                    Step1PersonalView(viewModel: viewModel, currentStep: $currentStep)
                } else if currentStep == 2 {
                    Step2HousingView(viewModel: viewModel, currentStep: $currentStep)
                } else if currentStep == 3 {
                    Step3LifestyleView(viewModel: viewModel, currentStep: $currentStep)
                } else if currentStep == 4 {
                    Step4InterestsView(viewModel: viewModel, currentStep: $currentStep)
                }
            }
        }
        .onAppear {
            // Hide tab bar
            NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil)
            // Load existing profile data
            viewModel.loadProfile()
            if viewModel.profile.name.isEmpty {
                if let uid = Auth.auth().currentUser?.uid {
                    let db = Firestore.firestore()
                    db.collection("users").document(uid).getDocument { snapshot, error in
                        if let data = snapshot?.data(),
                           let name = data["name"] as? String {
                            DispatchQueue.main.async {
                                if self.viewModel.profile.name.isEmpty {
                                    self.viewModel.profile.name = name
                                }
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
        }
        .navigationBarBackButtonHidden(!isEditMode)
        .onChange(of: viewModel.isSaved) { saved in
            if saved {
                if isEditMode {
                    // In edit mode just go back
                    NotificationCenter.default.post(name: Notification.Name("showTabBar"), object: nil)
                    dismiss()
                    
                } else {
                    // New profile setup - navigate to main app
                    NotificationCenter.default.post(name: Notification.Name("profileSaved"), object: nil)
                }
            }
        }
    }
}

// Hex colour extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// Progress bar
struct ProgressBarView: View {
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...totalSteps, id: \.self) { step in
                RoundedRectangle(cornerRadius: 4)
                    .fill(step <= currentStep ?
                          Color(red: 0.498, green: 0.467, blue: 0.867) :
                            Color.gray.opacity(0.3))
                    .frame(height: 6)
            }
        }
    }
}


//  - Step 1: Personal Info











struct Step1PersonalView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var currentStep: Int
    
    // Photo picker state
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var profileImage: UIImage? = nil
    @State private var isLoadingImage = false
    @State private var showOptions = false
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    
    let genderOptions = ["Male", "Female", "Non-binary", "Prefer not to say"]
    
    func loadImageIfNeeded() {
        guard !viewModel.profile.profileImageURL.isEmpty,
              profileImage == nil,
              !isLoadingImage else { return }
        
        isLoadingImage = true
        guard let url = URL(string: viewModel.profile.profileImageURL) else { return }
        
        // Use Kingfisher for cached image loading
            KingfisherManager.shared.retrieveImage(with: url) { result in
                DispatchQueue.main.async {
                    self.isLoadingImage = false
                    if case .success(let value) = result {
                        self.profileImage = value.image
                        self.viewModel.selectedImage = value.image
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Profile photo + heading centred at top
                VStack(spacing: 12) {
                    
                    // Profile photo circle
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 110, height: 110)
                        
                        if let image = profileImage {
                            // Show selected image
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                        } else {
                            // Show placeholder icon
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .foregroundColor(.gray)
                        }
                        
                        // Camera icon in bottom right
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color(red: 0.498, green: 0.467, blue: 0.867))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                    )
                            }
                        }
                        .frame(width: 110, height: 110)
                    }
                    .onTapGesture {
                        showOptions = true
                    }
                    .confirmationDialog("Choose Photo", isPresented: $showOptions) {
                        Button("Choose from Album") {
                            showPhotoPicker = true
                        }
                        Button("Take Photo") {
                            showCamera = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhoto, matching: .images)
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                profileImage = image
                                viewModel.selectedImage = image
                            }
                        }
                    }
                    .onAppear {
                        loadImageIfNeeded()
                    }
                    .onChange(of: viewModel.profile.profileImageURL) { _ in
                        loadImageIfNeeded()
                    }
                    .sheet(isPresented: $showCamera) {
                        CameraView(image: $profileImage)
                    }
                    .onChange(of: profileImage) { newImage in
                        viewModel.selectedImage = newImage
                    }
                    // Heading centred under photo
                    Text("Personal Info")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    
                    Text("Tell us about yourself")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                
                // Full name  pre-filled from registration
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    TextField("Your name", text: $viewModel.profile.name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                // Age
                VStack(alignment: .leading, spacing: 8) {
                    Text("Age")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    TextField("Your age", value: $viewModel.profile.age, format: .number)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .keyboardType(.numberPad)
                }
                
                // Gender
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gender")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Gender", selection: $viewModel.profile.gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // University
                VStack(alignment: .leading, spacing: 8) {
                    Text("University")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    TextField("Your university", text: $viewModel.profile.university)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                // Course
                VStack(alignment: .leading, spacing: 8) {
                    Text("Course")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    TextField("Your course", text: $viewModel.profile.course)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                
                // Bio
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bio")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    TextField("Tell potential roommates about yourself...", text: $viewModel.profile.bio, axis: .vertical)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .lineLimit(4...6)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                
                // Next button
                Button(action: {
                    guard !viewModel.profile.name.isEmpty else {
                        viewModel.errorMessage = "Please enter your name"
                        return
                    }
                    guard !viewModel.profile.university.isEmpty else {
                        viewModel.errorMessage = "Please enter your university"
                        return
                    }
                    guard !viewModel.profile.gender.isEmpty else {
                        viewModel.errorMessage = "Please select your gender"
                        return
                    }
                    viewModel.errorMessage = ""
                    currentStep = 2
                }) {
                    Text("Next")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}




// Step 2: Housing Preferences










struct Step2HousingView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var currentStep: Int
    
    let ukAreas = [
        "Central London", "North London", "South London", "East London", "West London",
        "Manchester", "Birmingham", "Leeds", "Sheffield", "Liverpool",
        "Bristol", "Newcastle", "Nottingham", "Leicester", "Coventry",
        "Southampton", "Portsmouth", "Brighton", "Oxford", "Cambridge",
        "Edinburgh", "Glasgow", "Cardiff", "Belfast", "Reading",
        "Milton Keynes", "Derby", "Exeter", "York", "Bath"
    ]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Housing Preferences")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    Text("What are you looking for?")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Monthly budget slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Budget (£\(viewModel.profile.budget))")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Slider(value: Binding(
                        get: { Double(viewModel.profile.budget) },
                        set: { viewModel.profile.budget = Int($0) }
                    ), in: 300...3000, step: 50)
                    .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                    HStack {
                        Text("£300")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("£3000")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                // Preferred area  full UK list
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preferred Area")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Preferred Area", selection: $viewModel.profile.preferredArea) {
                        Text("Select area").tag("")
                        ForEach(ukAreas, id: \.self) { area in
                            Text(area).tag(area)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                
                
                // Move in date stored as Date
                VStack(alignment: .leading, spacing: 8) {
                    Text("Move In Date")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    DatePicker(
                        "Move In Date",
                        selection: $viewModel.profile.moveInDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                
                // Back and Next buttons
                Spacer()
                HStack(spacing: 16) {
                    Button(action: { currentStep = 1 }) {
                        Text("Back")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    Button(action: {
                        guard !viewModel.profile.preferredArea.isEmpty else {
                            viewModel.errorMessage = "Please select your preferred area"
                            return
                        }
                        viewModel.errorMessage = ""
                        currentStep = 3
                    }) {
                        Text("Next")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}







//- Step 3: Lifestyle









struct Step3LifestyleView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var currentStep: Int
    
    let sleepOptions = ["Early bird", "Night owl", "Flexible"]
    let guestOptions = ["Rarely", "Sometimes", "Often"]
    let noiseOptions = ["Low", "Medium", "High"]
    let homeOptions = ["Rarely home", "Sometimes", "Always home"]
    let dietOptions = ["No preference", "Vegetarian", "Vegan", "Halal", "Other"]
    let studyOptions = ["Morning", "Afternoon", "Night", "No fixed schedule"]
    let privacyOptions = ["Very private", "Moderate", "Open"]
    let communicationOptions = ["Direct", "Laid back", "Prefer texting"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Lifestyle")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    Text("Help us find your perfect match")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Cleanliness slider
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cleanliness Level (\(viewModel.profile.cleanliness)/5)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Slider(value: Binding(
                        get: { Double(viewModel.profile.cleanliness) },
                        set: { viewModel.profile.cleanliness = Int($0) }
                    ), in: 1...5, step: 1)
                    .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                    HStack {
                        Text("Not bothered")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Very clean")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                // Sleep schedule
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sleep Schedule")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Sleep Schedule", selection: $viewModel.profile.sleepSchedule) {
                        ForEach(sleepOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Smoker toggle
                Toggle(isOn: $viewModel.profile.isSmoker) {
                    Text("Smoker")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Pet friendly toggle
                Toggle(isOn: $viewModel.profile.isPetFriendly) {
                    Text("Pet Friendly")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
                .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Guest frequency
                VStack(alignment: .leading, spacing: 8) {
                    Text("Guest Frequency")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Guest Frequency", selection: $viewModel.profile.guestFrequency) {
                        ForEach(guestOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Noise tolerance
                VStack(alignment: .leading, spacing: 8) {
                    Text("Noise Tolerance")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Noise Tolerance", selection: $viewModel.profile.noiseTolerance) {
                        ForEach(noiseOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Home presence
                VStack(alignment: .leading, spacing: 8) {
                    Text("Home Presence")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Home Presence", selection: $viewModel.profile.homePresence) {
                        ForEach(homeOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Diet
                VStack(alignment: .leading, spacing: 8) {
                    Text("Diet")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Diet", selection: $viewModel.profile.diet) {
                        ForEach(dietOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    .background(Color.white)
                    .cornerRadius(12)
                }

                // Study schedule
                VStack(alignment: .leading, spacing: 8) {
                    Text("Study Schedule")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Study Schedule", selection: $viewModel.profile.studySchedule) {
                        ForEach(studyOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Privacy level
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Level")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Privacy Level", selection: $viewModel.profile.privacyLevel) {
                        ForEach(privacyOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Communication style
                VStack(alignment: .leading, spacing: 8) {
                    Text("Communication Style")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    Picker("Communication Style", selection: $viewModel.profile.communicationStyle) {
                        ForEach(communicationOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                HStack(spacing: 16) {
                    Button(action: { currentStep = 2 }) {
                        Text("Back")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    Button(action: { currentStep = 4 }) {
                        Text("Next")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}




//  - Step 4: Interests









struct Step4InterestsView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var currentStep: Int
    
    let hobbyOptions = [
        "Gaming", "Cooking", "Football", "Basketball", "Reading",
        "Music", "Gym", "Cycling", "Travel", "Art",
        "Photography", "Dancing", "Hiking", "Swimming", "Netflix",
        "Anime", "Fashion", "Yoga", "Tennis", "Running",
        "Climbing", "Boxing", "Chess", "Coding", "Painting",
        "Singing", "Poetry", "Skateboarding", "Surfing", "Volunteering",
        "Meditation", "Languages", "Baking", "Gardening", "Cars"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Interests")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                    Text("Select all that apply")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top)
                
                // Hobby grid - 3 columns
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(hobbyOptions, id: \.self) { hobby in
                        let isSelected = viewModel.profile.hobbies.contains(hobby)
                        Button(action: {
                            if isSelected {
                                viewModel.profile.hobbies.removeAll { $0 == hobby }
                            } else {
                                viewModel.profile.hobbies.append(hobby)
                            }
                        }) {
                            Text(hobby)
                                .font(.system(size: 14))
                                .foregroundColor(isSelected ? .white : Color(red: 0.498, green: 0.467, blue: 0.867))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(isSelected ? Color(red: 0.498, green: 0.467, blue: 0.867) : Color.white)
                                .cornerRadius(20)
                        }
                    }
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                }
                
                HStack(spacing: 16) {
                    Button(action: { currentStep = 3 }) {
                        Text("Back")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    
                    // Save button
                    Button(action: {
                        viewModel.saveProfile(image: viewModel.selectedImage)
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Profile")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.498, green: 0.467, blue: 0.867))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}





// Camera view using UIImagePickerController
struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // Use camera as the source
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Coordinator handles the delegate callbacks
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        // Called when user takes a photo
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
        
        // Called when user cancels
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    ProfileSetupView()
}







