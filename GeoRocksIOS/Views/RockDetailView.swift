//
//  RockDetailView.swift
//  GeoRocksIOS
//
//  Created by YourName on Today's Date.
//

import SwiftUI
import AVKit

struct RockDetailView: View {
    let rockId: String
    
    @StateObject var detailViewModel = RockDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let detail = detailViewModel.rockDetail {
                    
                    // Main image
                    AsyncImage(url: URL(string: detail.image ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 250)
                    .clipped()
                    
                    // Title
                    Text(detail.title ?? "Unknown Title")
                        .font(.title)
                        .padding(.top, 8)
                    
                    // Basic info
                    Text("Type: \(detail.aMemberOf ?? "N/A")")
                    Text("Color: \(detail.color ?? "N/A")")
                    Text("Hardness: \(detail.physicalProperties?.hardness?.description ?? "N/A")")

                    
                    // Video
                    if let videoURLString = detail.video,
                       let videoURL = URL(string: videoURLString) {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .frame(height: 200)
                    }
                    
                    // Map
                    if let lat = detail.latitude, let lon = detail.longitude {
                        MapView(lat: lat, lon: lon)
                            .frame(height: 200)
                    }
                    
                    // Long description
                    if let description = detail.longDesc {
                        Text(description)
                            .padding(.horizontal)
                    }
                    
                } else {
                    ProgressView("Loading rock detail...")
                }
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Rock Detail")
        .onAppear {
            detailViewModel.fetchRockDetail(rockId: rockId)
        }
    }
}
