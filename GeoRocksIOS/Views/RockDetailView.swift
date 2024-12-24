//
//  RockDetailView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI
import AVKit
import MapKit

struct RockDetailView: View {
    let rockId: String
    
    // The RockDetailViewModel is observed to manage data and state.
    @StateObject var detailViewModel = RockDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // A loading state is shown while data is being fetched.
                if detailViewModel.isLoading {
                    ProgressView("Loading rock details...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                        .scaleEffect(1.5)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                }
                // If there is an error, an error message is displayed.
                else if let error = detailViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                }
                // If the data is successfully loaded, the rock detail is displayed.
                else if let detail = detailViewModel.rockDetail {
                    
                    // MARK: - Main Image
                    // A main image is displayed at the top, inside a coffee-colored box.
                    if let imageUrl = detail.image, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .overlay(
                                        ProgressView()
                                            .progressViewStyle(
                                                CircularProgressViewStyle(tint: Color("ButtonDefault"))
                                            )
                                    )
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 250)
                                    .clipped()
                            case .failure:
                                Color.red
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.white)
                                            .font(.largeTitle)
                                    )
                            @unknown default:
                                Color.gray
                                    .aspectRatio(16/9, contentMode: .fit)
                            }
                        }
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Title
                    // A title is displayed in a coffee-colored box with a corner radius and shadow.
                    Text(detail.title ?? "Rock Details")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("DefaultTextColor"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
                    // MARK: - Basic Information
                    // Basic rock information is displayed in a coffee-colored box.
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(title: "Type", value: detail.aMemberOf ?? "N/A")
                        InfoRow(title: "Color", value: detail.color ?? "N/A")
                        InfoRow(title: "Formula", value: detail.formula ?? "N/A")
                        InfoRow(title: "Hardness", value: "\(detail.hardness ?? 0)")
                        InfoRow(title: "Magnetic", value: detail.magnetic == true ? "Yes" : "No")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("CoffeeBackground")) // New coffee color
                    )
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    // MARK: - Also Known As
                    // If alternate names exist, they are displayed in a coffee-colored box.
                    if let alsoKnownAs = detail.alsoKnownAs, !alsoKnownAs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Also Known As")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            ForEach(alsoKnownAs, id: \.self) { name in
                                Text("• \(name)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("DefaultTextColor"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Video
                    // A video player is displayed inside a coffee-colored box if a valid URL is provided.
                    if let videoURLString = detail.video,
                       let videoURL = URL(string: videoURLString) {
                        VStack {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Location (Map)
                    // A map is shown if valid latitude and longitude are available, inside a coffee-colored box.
                    if let lat = detail.latitude, let lon = detail.longitude {
                        VStack {
                            MapView(lat: lat, lon: lon)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Long Description (with a lighter gradient)
                    // A lighter gradient is used for the long description to set it apart, still in coffee tones.
                    if let description = detail.longDesc {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(description)
                                .font(.body)
                                .foregroundColor(Color("DefaultTextColor"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color("CoffeeBackground").opacity(0.9),
                                        Color("CoffeeBackground").opacity(0.6)
                                    ]
                                ),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Physical Properties
                    // Physical properties are displayed in a coffee-colored box.
                    if let physicalProperties = detail.physicalProperties {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Physical Properties")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            InfoRow(title: "Crystal System", value: physicalProperties.ppCrystalSystem ?? "N/A")
                            InfoRow(
                                title: "Colors",
                                value: physicalProperties.ppColors?.joined(separator: ", ") ?? "N/A"
                            )
                            InfoRow(title: "Luster", value: physicalProperties.ppLuster ?? "N/A")
                            InfoRow(title: "Diaphaneity", value: physicalProperties.ppDiaphaneity ?? "N/A")
                            InfoRow(title: "Streak", value: physicalProperties.ppStreak ?? "N/A")
                            InfoRow(title: "Tenacity", value: physicalProperties.ppTenacity ?? "N/A")
                            InfoRow(title: "Cleavage", value: physicalProperties.ppCleavage ?? "N/A")
                            InfoRow(title: "Fracture", value: physicalProperties.ppFracture ?? "N/A")
                            InfoRow(title: "Density", value: physicalProperties.ppDensity ?? "N/A")
                            InfoRow(
                                title: "Hardness (Physical)",
                                value: "\(physicalProperties.ppHardness ?? 0)"
                            )
                            InfoRow(
                                title: "Magnetic (Physical)",
                                value: physicalProperties.ppMagnetic == true ? "Yes" : "No"
                            )
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Chemical Properties
                    // Chemical properties are displayed in a coffee-colored box.
                    if let chemicalProperties = detail.chemicalProperties {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chemical Properties")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            InfoRow(
                                title: "Chemical Classification",
                                value: chemicalProperties.chemicalClassification ?? "N/A"
                            )
                            InfoRow(
                                title: "Formula (Chemical)",
                                value: chemicalProperties.cpFormula ?? "N/A"
                            )
                            
                            if let elementsListed = chemicalProperties.cpElementsListed,
                               !elementsListed.isEmpty {
                                InfoRow(
                                    title: "Elements Listed",
                                    value: elementsListed.joined(separator: ", ")
                                )
                            } else {
                                InfoRow(title: "Elements Listed", value: "N/A")
                            }
                            
                            if let commonImpurities = chemicalProperties.cpCommonImpurities,
                               !commonImpurities.isEmpty {
                                InfoRow(
                                    title: "Common Impurities",
                                    value: commonImpurities.joined(separator: ", ")
                                )
                            } else {
                                InfoRow(title: "Common Impurities", value: "N/A")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Health Risks
                    // Health risk information is displayed if it exists, inside a coffee-colored box.
                    if let healthRisks = detail.healthRisks, !healthRisks.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Health Risks")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            Text(healthRisks)
                                .font(.subheadline)
                                .foregroundColor(Color("DefaultTextColor"))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Additional Images
                    // Additional images are displayed in a horizontal scroll view, inside a coffee-colored box.
                    if let additionalImages = detail.images, !additionalImages.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Images")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(additionalImages, id: \.self) { imageURL in
                                        if let url = URL(string: imageURL) {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .progressViewStyle(
                                                            CircularProgressViewStyle(
                                                                tint: Color("ButtonDefault")
                                                            )
                                                        )
                                                        .frame(width: 120, height: 80)
                                                        .background(Color.gray)
                                                        .cornerRadius(8)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 120, height: 80)
                                                        .clipped()
                                                        .cornerRadius(8)
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 120, height: 80)
                                                        .foregroundColor(.white)
                                                        .background(Color.red)
                                                        .cornerRadius(8)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Localities
                    // A list of localities is displayed if they exist, inside a coffee-colored box.
                    if let localities = detail.localities, !localities.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Localities")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            ForEach(localities, id: \.self) { locality in
                                Text("• \(locality)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("DefaultTextColor"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Frequently Asked Questions (Wider Box)
                    // A coffee-colored box with wider padding is used to display FAQs.
                    if let faqs = detail.frequentlyAskedQuestions, !faqs.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequently Asked Questions")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            ForEach(faqs, id: \.self) { faq in
                                Text("• \(faq)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("DefaultTextColor"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                        // The box width is increased by using more horizontal padding.
                        .padding(.horizontal, 32)
                    }
                }
                // If no data is available, a message is displayed in a coffee-colored box.
                else {
                    Text("No rock details available.")
                        .foregroundColor(.gray)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("CoffeeBackground")) // New coffee color
                        )
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("Rock Detail")
        .onAppear {
            // The rock details are fetched when the view appears.
            detailViewModel.fetchRockDetail(rockId: rockId)
        }
        .alert(isPresented: Binding<Bool>(
            get: { self.detailViewModel.error != nil },
            set: { _ in self.detailViewModel.error = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(detailViewModel.error ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - InfoRow
// A reusable view is provided for displaying a labeled piece of information in a row.
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(title):")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(Color("DefaultTextColor"))
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(Color("DefaultTextColor"))
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
struct RockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RockDetailView(rockId: "1")
            .environmentObject(AuthViewModel())
    }
}
