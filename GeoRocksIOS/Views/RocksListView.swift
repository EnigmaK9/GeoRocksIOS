// RocksListView.swift

import SwiftUI

struct RocksListView: View {
    @StateObject var rocksViewModel = RocksViewModel()
    
    var body: some View {
        VStack {
            if rocksViewModel.isLoading {
                ProgressView("Loading Rocks...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
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
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray
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
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("RockList")
        .onAppear {
            rocksViewModel.fetchRocks()
        }
    }
}

struct RocksListView_Previews: PreviewProvider {
    static var previews: some View {
        RocksListView()
    }
}
