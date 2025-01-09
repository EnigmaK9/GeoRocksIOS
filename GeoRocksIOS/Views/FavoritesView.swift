//
//  FavoritesView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//
//  Description:
//  The FavoritesView displays a list of rocks that have been marked as favorites by the user.
//  Users can navigate to this view to easily access their preferred rocks.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel // Accesses the shared RocksViewModel
    
    var body: some View {
        VStack {
            // Title for the Favorites section
            Text("Your Favorite Rocks")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("DefaultTextColor"))
                .padding(.top, 20)
            
            // Checks if there are any favorites
            if rocksViewModel.favoriteRockIDs.isEmpty {
                // Message displayed when no favorites are selected
                Text("You have not added any rocks to your favorites yet.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            else {
                // List of favorite rocks is displayed
                List {
                    ForEach(rocksViewModel.rocks.filter { rocksViewModel.isFavorite(rock: $0) }) { rock in
                        NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                            HStack(spacing: 12) {
                                // Thumbnail image for the rock
                                if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            // Placeholder while the image is loading
                                            Color.gray
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    ProgressView()
                                                        .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                                )
                                        case .success(let image):
                                            // Successfully loaded image
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipped()
                                        case .failure:
                                            // Placeholder for failed image loading
                                            Color.red
                                                .frame(width: 50, height: 50)
                                                .overlay(
                                                    Image(systemName: "photo")
                                                        .foregroundColor(.white)
                                                )
                                        @unknown default:
                                            // Fallback for any unknown cases
                                            Color.gray
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                    .cornerRadius(8)
                                    .shadow(radius: 3)
                                } else {
                                    // Placeholder for missing image
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                }
                                
                                // Rock title with improved typography
                                Text(rock.title)
                                    .font(.headline)
                                    .foregroundColor(Color("DefaultTextColor"))
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                // Unfavorite button to remove the rock from favorites
                                Button(action: {
                                    rocksViewModel.toggleFavorite(rock: rock)
                                }) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle()) // Ensures the button works inside the list
                            }
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 3)
                            .padding(.horizontal)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("BackgroundColor"))
            }
            
            Spacer()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all)) // Sets the background color
        .navigationTitle("Favorites") // Sets the navigation title
    }
    
    struct FavoritesView_Previews: PreviewProvider {
        static var previews: some View {
            FavoritesView()
                .environmentObject(RocksViewModel()) // Provides the RocksViewModel for preview
        }
    }
}
