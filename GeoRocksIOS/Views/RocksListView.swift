//
//  RocksListView.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI

struct RocksListView: View {
    @StateObject var rocksViewModel = RocksViewModel()
    
    var body: some View {
        VStack {
            // Loading state: shows a spinner while data is fetched
            if rocksViewModel.isLoading {
                ProgressView("Loading Rocks...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                    .scaleEffect(1.5)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                    .shadow(radius: 5)
            }
            // Error state: displays an error message if fetching data fails
            else if let errorMessage = rocksViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                    .shadow(radius: 5)
            }
            // Success state: displays a list of rocks
            else {
                List(rocksViewModel.rocks) { rock in
                    NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                        HStack(spacing: 12) {
                            // Thumbnail image for the rock
                            if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                            )
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipped()
                                    case .failure:
                                        Color.red
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.white)
                                            )
                                    @unknown default:
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
                        }
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                        .shadow(radius: 3)
                        .padding(.horizontal)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("BackgroundColor"))
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("Rocks List")
        .onAppear {
            // Fetches rocks when the view appears
            rocksViewModel.fetchRocks()
        }
    }
}

struct RocksListView_Previews: PreviewProvider {
    static var previews: some View {
        RocksListView()
            .environmentObject(AuthViewModel())
    }
}
