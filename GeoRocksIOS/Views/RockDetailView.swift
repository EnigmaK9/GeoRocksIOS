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

    // Observes the RockDetailViewModel to manage data and state
    @StateObject var detailViewModel = RockDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Loading state: shows a spinner when data is being fetched
                if detailViewModel.isLoading {
                    ProgressView("Loading rock details...")
                        .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                        .scaleEffect(1.5)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                }
                // Error state: displays an error message if fetching data fails
                else if let error = detailViewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                }
                // Success state: displays rock details
                else if let detail = detailViewModel.rockDetail {

                    // Main Image with fixed constraints and fallback content
                    if let imageUrl = detail.image, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                Color.gray
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .overlay(
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
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

                    // Title with enhanced typography
                    Text(detail.title ?? "Unknown Title")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("DefaultTextColor"))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                        .padding(.horizontal)

                    // Basic Information Section with background boxes
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(title: "Type", value: detail.aMemberOf ?? "N/A")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("DefaultBackground")))
                            .shadow(radius: 5)
                        InfoRow(title: "Color", value: detail.color ?? "N/A")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("DefaultBackground")))
                            .shadow(radius: 5)
                        InfoRow(title: "Hardness", value: "\(detail.hardness ?? 0)")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("DefaultBackground")))
                            .shadow(radius: 5)
                        InfoRow(title: "Magnetic", value: detail.magnetic == true ? "Yes" : "No")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("DefaultBackground")))
                            .shadow(radius: 5)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                    .shadow(radius: 5)
                    .padding(.horizontal)

                    // Video Player for rock-related videos
                    if let videoURLString = detail.video,
                       let videoURL = URL(string: videoURLString) {
                        VStack {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }

                    // Map View for displaying rock location
                    if let lat = detail.latitude, let lon = detail.longitude {
                        VStack {
                            MapView(lat: lat, lon: lon)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }

                    // Long Description of the rock
                    if let description = detail.longDesc {
                        Text(description)
                            .font(.body)
                            .padding()
                            .foregroundColor(Color("DefaultTextColor"))
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }

                    // Frequently Asked Questions Section with new tone
                    if let faqs = detail.offFrequentlyAskedQuestions {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frequently Asked Questions:")
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
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("ButtonDefault")))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                    }
                }
                // Empty state: no data available
                else {
                    Text("No rock details available.")
                        .foregroundColor(.gray)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 5)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("Rock Detail")
        .onAppear {
            // Triggers fetching of rock details when the view appears
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

// Reusable view for displaying a row of labeled information
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

struct RockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RockDetailView(rockId: "1")
            .environmentObject(AuthViewModel())
    }
}
