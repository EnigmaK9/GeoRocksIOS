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
            if rocksViewModel.isLoading {
                ProgressView("Loading Rocks...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .foregroundColor(Color("ButtonDefault"))
            } else if let errorMessage = rocksViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(rocksViewModel.rocks) { rock in
                    NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                        HStack {
                            if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    case .failure:
                                        Color.red
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(8)
                            } else {
                                Color.gray
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            }
                            
                            Text(rock.title)
                                .font(.headline)
                                .padding(.leading, 8)
                                .foregroundColor(Color("DefaultTextColor"))
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Rocks List")
        .onAppear {
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
