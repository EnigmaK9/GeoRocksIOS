// -----------------------------------------------------------
// AddNewRockView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file provides a professional SwiftUI view for adding
// a new rock to the collection. The interface has been
// enhanced with organized sections, improved form inputs,
// and intuitive user interaction elements.
// -----------------------------------------------------------

import SwiftUI
import PhotosUI // Add this line if it's not already present

struct AddNewRockView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var rockName: String = ""
    @State private var rockType: String = ""
    @State private var locationFound: String = ""
    @State private var description: String = ""
    @State private var dateFound: Date = Date()
    @State private var rockImage: Image? = nil
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var isFavorite: Bool = false
    @State private var showAlert = false
    
    @State private var isSaving = false
    @State private var saveErrorMessage: String? = nil
    @State private var showSaveErrorAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                // Rock Details Section
                Section(header: Text("Rock Details")) {
                    TextField("Rock Name", text: $rockName)
                        .autocapitalization(.words)
                    
                    Picker("Rock Type", selection: $rockType) {
                        ForEach(rockTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("Location Found", text: $locationFound)
                        .autocapitalization(.words)
                    
                    DatePicker("Date Found", selection: $dateFound, displayedComponents: .date)
                }
                
                // Description Section
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                // Image Section
                Section(header: Text("Photo")) {
                    if let rockImage = rockImage {
                        rockImage
                             .resizable()
                             .scaledToFit()
                             .frame(height: 200)
                             .cornerRadius(10)
                             .onTapGesture {
                                 isShowingImagePicker = true
                             }
                    } else {
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            HStack {
                                Image(systemName: "camera")
                                Text("Add a Photo")
                            }
                        }
                    }
                }
                
                // Additional Options Section
                Section {
                    Toggle(isOn: $isFavorite) {
                        Text("Mark as Favorite")
                    }
                }
                
                // Save Button Section
                Section {
                    Button(action: {
                        // Validation and Save Action
                        if rockName.isEmpty || rockType.isEmpty {
                            showAlert = true
                        } else {
                            isSaving = true
                            NetworkingService.shared.createRockSample(
                                name: rockName,
                                description: description,
                                location: locationFound
                            ) { result in
                                DispatchQueue.main.async {
                                    isSaving = false
                                    switch result {
                                    case .success:
                                        // Refresh the main catalog
                                        rocksViewModel.fetchRocks()
                                        // Dismiss the addition sheet
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        saveErrorMessage = error.localizedDescription
                                        showSaveErrorAlert = true
                                    }
                                }
                            }
                        }
                    }) {
                        if isSaving {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("Save Rock")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(isSaving)
                }
            }
            .navigationTitle("Add New Rock")
            .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Information"),
                    message: Text("Please fill in all required fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showSaveErrorAlert) {
                Alert(
                    title: Text("Error al guardar"),
                    message: Text(saveErrorMessage ?? "Ocurrió un error inesperado al registrar el espécimen."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Helper function to load the selected image
    func loadImage() {
        guard let inputImage = inputImage else { return }
        rockImage = Image(uiImage: inputImage)
    }
    
    // Sample Rock Types
    var rockTypes: [String] = [
        "Igneous",
        "Sedimentary",
        "Metamorphic",
        "Mineral",
        "Fossil"
    ]
}

struct AddNewRockView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewRockView()
            .environmentObject(RocksViewModel())
    }
}
