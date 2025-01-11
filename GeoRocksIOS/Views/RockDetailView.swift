// RockDetailView.swift
// GeoRocksIOS

import SwiftUI
import AVKit
import MapKit

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

struct RockDetailView: View {
    let rockId: String
    
    @StateObject var detailViewModel = RockDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if detailViewModel.isLoading {
                    ProgressView("Loading rock details...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                        .scaleEffect(1.5)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CoffeeBackground")))
                        .shadow(radius: 5)
                } else if let error = detailViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("CoffeeBackground")))
                        .shadow(radius: 5)
                } else if let detail = detailViewModel.rockDetail {
                    Text(detail.title ?? "Rock Details")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("DefaultTextColor"))
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    if let lat = detail.latitude, let lon = detail.longitude {
                        VStack {
                            MapView(lat: lat, lon: lon)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(title: "Type", value: detail.aMemberOf ?? "N/A")
                        InfoRow(title: "Color", value: detail.color ?? "N/A")
                        InfoRow(title: "Formula", value: detail.formula ?? "N/A")
                        InfoRow(title: "Hardness", value: "\(detail.hardness ?? 0)")
                        InfoRow(title: "Magnetic", value: detail.magnetic == true ? "Yes" : "No")
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                    if let physicalProperties = detail.physicalProperties {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Physical Properties")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            InfoRow(title: "Crystal System", value: physicalProperties.ppCrystalSystem ?? "N/A")
                            InfoRow(title: "Colors", value: physicalProperties.ppColors?.joined(separator: ", ") ?? "N/A")
                            InfoRow(title: "Luster", value: physicalProperties.ppLuster ?? "N/A")
                            InfoRow(title: "Diaphaneity", value: physicalProperties.ppDiaphaneity ?? "N/A")
                            InfoRow(title: "Streak", value: physicalProperties.ppStreak ?? "N/A")
                            InfoRow(title: "Tenacity", value: physicalProperties.ppTenacity ?? "N/A")
                            InfoRow(title: "Cleavage", value: physicalProperties.ppCleavage ?? "N/A")
                            InfoRow(title: "Fracture", value: physicalProperties.ppFracture ?? "N/A")
                            InfoRow(title: "Density", value: physicalProperties.ppDensity ?? "N/A")
                            InfoRow(title: "Hardness (Physical)", value: "\(physicalProperties.ppHardness ?? 0)")
                            InfoRow(title: "Magnetic (Physical)", value: physicalProperties.ppMagnetic == true ? "Yes" : "No")
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
                    if let chemicalProperties = detail.chemicalProperties {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chemical Properties")
                                .font(.headline)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            InfoRow(title: "Chemical Classification", value: chemicalProperties.chemicalClassification ?? "N/A")
                            InfoRow(title: "Formula (Chemical)", value: chemicalProperties.cpFormula ?? "N/A")
                            if let elementsListed = chemicalProperties.cpElementsListed, !elementsListed.isEmpty {
                                InfoRow(title: "Elements Listed", value: elementsListed.joined(separator: ", "))
                            } else {
                                InfoRow(title: "Elements Listed", value: "N/A")
                            }
                            if let commonImpurities = chemicalProperties.cpCommonImpurities, !commonImpurities.isEmpty {
                                InfoRow(title: "Common Impurities", value: commonImpurities.joined(separator: ", "))
                            } else {
                                InfoRow(title: "Common Impurities", value: "N/A")
                            }
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                                                            CircularProgressViewStyle(tint: Color("ButtonDefault"))
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                    
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
                            LinearGradient(
                                gradient: Gradient(colors: [Color("CoffeeBackground"), Color("ButtonDefault")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.horizontal, 32)
                    }
                    
                    ShareRockFeature(
                        rockTitle: detail.title ?? "",
                        rockDetails: detail.longDesc ?? "No details available"
                    )
                    .padding(.top, 16)
                }
            }
            .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
            .onAppear {
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
}

struct RockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RockDetailView(rockId: "1")
            .environmentObject(AuthViewModel())
    }
}
