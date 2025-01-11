// AddRockView.swift
// GeoRocksIOS
//
// This file is intended to add new rocks locally in the frontend.
// It is assumed that this view will be presented inside a NavigationView.
// To make it function:
// 1) Add this file to your project.
// 2) Inject RocksViewModel with .environmentObject(...) where needed.
// 3) Navigate to AddRockView from any existing view.
//
// Implementation is kept minimal. The user inputs a title and thumbnail URL.
// On tapping 'Add Rock', the new rock is appended to the local rocks array.

import SwiftUI

struct AddRockView: View {
    // A reference to the RocksViewModel is declared. It is assumed to be injected at a higher level.
    @EnvironmentObject var rocksViewModel: RocksViewModel
    
    // State variables are declared to capture the user's inputs for the new rock.
    @State private var rockTitle: String = ""
    @State private var rockThumbnailURL: String = ""
    
    // The body property defines the user interface.
    var body: some View {
        NavigationView {
            Form {
                // A section is created for user inputs.
                Section(header: Text("Rock Information")) {
                    // A TextField is used to capture the title.
                    TextField("Enter Rock Title", text: $rockTitle)
                    
                    // A TextField is used to capture a thumbnail URL.
                    TextField("Enter Thumbnail URL", text: $rockThumbnailURL)
                }
                
                // A button is created to trigger the addition of the rock.
                Button(action: {
                    addRock()
                }) {
                    Text("Add Rock")
                }
            }
            .navigationTitle("Add New Rock")
        }
    }
    
    // MARK: - Add Rock Function
    // This function adds a new rock to the rocksViewModel with minimal validation.
    private func addRock() {
        // A simple guard is used to ensure a title was provided.
        guard !rockTitle.isEmpty else { return }
        
        // A new RockDto object is created.
        let newRock = RockDto(
            id: UUID().uuidString,      // A UUID is assigned as the ID (only local).
            thumbnail: rockThumbnailURL.isEmpty ? nil : rockThumbnailURL,
            title: rockTitle
        )
        
        // The new rock is appended to the local rocks array within RocksViewModel.
        rocksViewModel.rocks.append(newRock)
        
        // The fields are cleared for convenience.
        rockTitle = ""
        rockThumbnailURL = ""
    }
}

// MARK: - Preview
// A preview is provided for SwiftUI canvas usage.
struct AddRockView_Previews: PreviewProvider {
    static var previews: some View {
        AddRockView()
            .environmentObject(RocksViewModel())
    }
}
