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
    
    // The RockDetailViewModel is accessed and observed
    @StateObject var detailViewModel = RockDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if detailViewModel.isLoading {
                    // A loading indicator is displayed while data is being fetched
                    ProgressView("Loading rock details...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else if let error = detailViewModel.error {
                    // An error message is displayed if an error occurs
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if let detail = detailViewModel.rockDetail {
                    // Main image is displayed
                    if let imageUrl = detail.image, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .frame(height: 250)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 250)
                                    .clipped()
                            case .failure:
                                Color.red
                                    .frame(height: 250)
                            @unknown default:
                                Color.gray
                                    .frame(height: 250)
                            }
                        }
                        .cornerRadius(10)
                    }
                    
                    // Title is displayed
                    Text(detail.title ?? "Unknown Title")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("DefaultTextColor"))
                    
                    // Basic information is displayed
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type: \(detail.aMemberOf ?? "N/A")")
                        Text("Color: \(detail.color ?? "N/A")")
                        Text("Hardness: \(detail.hardness ?? 0)")
                        Text("Magnetic: \(detail.magnetic == true ? "Yes" : "No")")
                    }
                    .padding(.horizontal)
                    .foregroundColor(Color("DefaultTextColor"))
                    
                    // Video is displayed if available
                    if let videoURLString = detail.video,
                       let videoURL = URL(string: videoURLString) {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Map is displayed if coordinates are available
                    if let lat = detail.latitude, let lon = detail.longitude {
                        MapView(lat: lat, lon: lon)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Long description is displayed
                    if let description = detail.longDesc {
                        Text(description)
                            .padding(.horizontal)
                            .foregroundColor(Color("DefaultTextColor"))
                    }
                    
                    // Frequently Asked Questions are displayed
                    if let faqs = detail.offFrequentlyAskedQuestions {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequently Asked Questions:")
                                .font(.headline)
                                .padding(.top, 16)
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            ForEach(faqs, id: \.self) { faq in
                                Text("• \(faq)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("DefaultTextColor"))
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // A message is displayed if no data is available
                    Text("No rock details available.")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Rock Detail")
        .onAppear {
            // The fetchRockDetail function is called when the view appears
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

struct RockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RockDetailView(rockId: "1")
    }
}
