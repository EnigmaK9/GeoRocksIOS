// -----------------------------------------------------------
//  AddRockView.swift
//  GeoRocksIOS
//  Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
//  Description:
//  This file allows users to enter detailed information
//  for a new rock. After validation, the rock is saved
//  to local storage, and the user is navigated to a detail view.
// -----------------------------------------------------------

import SwiftUI

struct AddRockView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel
    
    @State private var rockTitle: String = ""
    @State private var rockThumbnailURL: String = ""
    @State private var rockColor: String = ""
    @State private var rockHardness: String = ""
    @State private var rockFormula: String = ""
    @State private var rockShortDescription: String = ""
    @State private var rockLatitude: String = ""
    @State private var rockLongitude: String = ""
    @State private var rockAMemberOf: String = "" // New property for rock classification
    @State private var rockHealthRisks: String = "" // New property for health risks
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // A state property is used for programmatic navigation.
    @State private var navigateToDetail: Bool = false
    
    // A state property is used to store the newly created rock for passing its ID to the detail view.
    @State private var newlyCreatedRock: RockDto? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Rock Information")) {
                    TextField("Enter Rock Title", text: $rockTitle)
                    TextField("Enter Thumbnail URL", text: $rockThumbnailURL)
                    TextField("Enter Color", text: $rockColor)
                    TextField("Enter Hardness (1-10)", text: $rockHardness)
                    TextField("Enter Formula", text: $rockFormula)
                    TextField("Enter Short Description", text: $rockShortDescription)
                    TextField("Enter Member Of (e.g., Igneous)", text: $rockAMemberOf) // New input
                    TextField("Enter Health Risks (if any)", text: $rockHealthRisks) // New input
                }
                
                Section(header: Text("Location (Optional)")) {
                    TextField("Enter Latitude", text: $rockLatitude)
                    TextField("Enter Longitude", text: $rockLongitude)
                }
                
                Button(action: {
                    addRock()
                }) {
                    Text("Add Rock")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.cornerRadius(8))
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Validation Error"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationTitle("Add New Rock")
            .background(
                // A hidden NavigationLink is used for programmatic navigation.
                NavigationLink(
                    destination: Group {
                        if let rock = newlyCreatedRock {
                            // RockDetailView(rockId:) is assumed, accepting a String
                            RockDetailView(rockId: rock.id)
                        } else {
                            Text("No Rock to display.")
                        }
                    },
                    isActive: $navigateToDetail,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()
            )
        }
    }
    
    /// A new rock is created and saved, then the view navigates to the rock detail.
    private func addRock() {
        // A minimal validation check is performed.
        guard !rockTitle.isEmpty else {
            alertMessage = "A rock title is required."
            showAlert = true
            return
        }
        
        // Strings are converted to numeric values if possible.
        let hardnessValue: Int? = Int(rockHardness)
        let latitudeValue: Double? = Double(rockLatitude)
        let longitudeValue: Double? = Double(rockLongitude)
        
        // A new RockDto object is constructed with a unique ID.
        let newRock = RockDto(
            id: UUID().uuidString,
            thumbnail: rockThumbnailURL.isEmpty ? nil : rockThumbnailURL,
            title: rockTitle,
            color: rockColor.isEmpty ? nil : rockColor,
            hardness: hardnessValue,
            formula: rockFormula.isEmpty ? nil : rockFormula,
            shortDescription: rockShortDescription.isEmpty ? nil : rockShortDescription,
            latitude: latitudeValue,
            longitude: longitudeValue,
            aMemberOf: rockAMemberOf.isEmpty ? nil : rockAMemberOf, // Include classification
            healthRisks: rockHealthRisks.isEmpty ? nil : rockHealthRisks // Include health risks
        )
        
        // The new rock is appended to the ViewModel, which performs local saving.
        rocksViewModel.addRock(newRock)
        
        // Text fields are cleared for convenience.
        rockTitle = ""
        rockThumbnailURL = ""
        rockColor = ""
        rockHardness = ""
        rockFormula = ""
        rockShortDescription = ""
        rockLatitude = ""
        rockLongitude = ""
        rockAMemberOf = "" // Clear classification field
        rockHealthRisks = "" // Clear health risks field
        
        // The newly created rock is stored, and navigation is triggered to the detail view.
        newlyCreatedRock = newRock
        navigateToDetail = true
    }
}
