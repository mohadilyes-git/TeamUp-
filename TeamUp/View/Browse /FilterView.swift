//
//  FilterView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 13/04/2026.
//



import SwiftUI

// Filter model to hold all filter values
struct FilterOptions {
    var preferredArea: String = ""
    var minBudget: Int = 300
    var maxBudget: Int = 3000
    var sleepSchedule: String = ""
    var nonSmokersOnly: Bool = false
    var petFriendlyOnly: Bool = false
    var genderPreference: String = ""
    var communicationStyle: String = ""
    var noiseTolerance: String = ""
    var guestFrequency: String = ""
}

struct FilterView: View {
    
    // Binding so BrowseView can read the filter values
    @Binding var filters: FilterOptions
    @Binding var isPresented: Bool
    
    // Local copy to edit before applying
    @State private var localFilters: FilterOptions
    
    let ukAreas = [
        "Central London", "North London", "South London", "East London", "West London",
        "Manchester", "Birmingham", "Leeds", "Sheffield", "Liverpool",
        "Bristol", "Newcastle", "Nottingham", "Leicester", "Coventry",
        "Southampton", "Portsmouth", "Brighton", "Oxford", "Cambridge",
        "Edinburgh", "Glasgow", "Cardiff", "Belfast", "Reading",
        "Milton Keynes", "Derby", "Exeter", "York", "Bath"
    ]
    
    let sleepOptions = ["", "Early bird", "Night owl", "Flexible"]
    let genderOptions = ["", "Male", "Female", "Non-binary", "Prefer not to say"]
    let communicationOptions = ["", "Direct", "Laid back", "Prefer texting"]
    let noiseOptions = ["", "Low", "Medium", "High"]
    let guestOptions = ["", "Rarely", "Sometimes", "Often"]
    
    init(filters: Binding<FilterOptions>, isPresented: Binding<Bool>) {
        self._filters = filters
        self._isPresented = isPresented
        self._localFilters = State(initialValue: filters.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6EC").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Preferred area
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Preferred Area")
                            Picker("Preferred Area", selection: $localFilters.preferredArea) {
                                Text("Any area").tag("")
                                ForEach(ukAreas, id: \.self) { area in
                                    Text(area).tag(area)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(height: 120)
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Budget range
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Budget Range (£\(localFilters.minBudget) - £\(localFilters.maxBudget))")
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Min: £\(localFilters.minBudget)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                Slider(value: Binding(
                                    get: { Double(localFilters.minBudget) },
                                    set: { localFilters.minBudget = Int($0) }
                                ), in: 300...3000, step: 50)
                                .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                                
                                HStack {
                                    Text("Max: £\(localFilters.maxBudget)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                Slider(value: Binding(
                                    get: { Double(localFilters.maxBudget) },
                                    set: { localFilters.maxBudget = Int($0) }
                                ), in: 300...3000, step: 50)
                                .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        // Sleep schedule
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Sleep Schedule")
                            Picker("Sleep Schedule", selection: $localFilters.sleepSchedule) {
                                ForEach(sleepOptions, id: \.self) { option in
                                    Text(option.isEmpty ? "Any" : option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Gender preference
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Gender")
                            Picker("Gender", selection: $localFilters.genderPreference) {
                                ForEach(genderOptions, id: \.self) { option in
                                    Text(option.isEmpty ? "Any" : option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Communication style
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Communication Style")
                            Picker("Communication", selection: $localFilters.communicationStyle) {
                                ForEach(communicationOptions, id: \.self) { option in
                                    Text(option.isEmpty ? "Any" : option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Noise tolerance
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Noise Tolerance")
                            Picker("Noise", selection: $localFilters.noiseTolerance) {
                                ForEach(noiseOptions, id: \.self) { option in
                                    Text(option.isEmpty ? "Any" : option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Guest frequency
                        VStack(alignment: .leading, spacing: 8) {
                            SectionLabel(title: "Guest Frequency")
                            Picker("Guests", selection: $localFilters.guestFrequency) {
                                ForEach(guestOptions, id: \.self) { option in
                                    Text(option.isEmpty ? "Any" : option).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // Smoker toggle
                        Toggle(isOn: $localFilters.nonSmokersOnly) {
                            Text("Non-smokers only")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Pet friendly toggle
                        Toggle(isOn: $localFilters.petFriendlyOnly) {
                            Text("Pet friendly only")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .tint(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        // Reset button
                        Button(action: {
                            localFilters = FilterOptions()
                        }) {
                            Text("Reset Filters")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        filters = localFilters
                        isPresented = false
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                }
            }
        }
    }
}

// Reusable section label
struct SectionLabel: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.gray)
    }
}

#Preview {
    FilterView(filters: .constant(FilterOptions()), isPresented: .constant(true))
}
