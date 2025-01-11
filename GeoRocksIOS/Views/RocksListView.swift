// RocksListView.swift
// GeoRocksIOS

import SwiftUI

struct RocksListView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var accountSettingsViewModel: AccountSettingsViewModel
    
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .ascending
    @State private var showingSettings = false
    @State private var showingAccountSettings = false
    @State private var showingAddRock = false
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    if rocksViewModel.isLoading {
                        ProgressView("Loading Rocks...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                            .scaleEffect(1.5)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 5)
                    } else if let errorMessage = rocksViewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 5)
                    } else {
                        List {
                            Section(header: SearchBar(text: $searchText)) {
                                Picker("Sort By", selection: $sortOption) {
                                    ForEach(SortOption.allCases) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.vertical, 5)
                                .onChange(of: sortOption) { _ in
                                    rocksViewModel.sortRocks(option: sortOption)
                                }
                                
                                ForEach(rocksViewModel.filteredAndSortedRocks(searchText: searchText)) { rock in
                                    NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                                        HStack(spacing: 12) {
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
                                                Color.gray
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                                    .shadow(radius: 3)
                                            }
                                            
                                            Text(rock.title)
                                                .font(.headline)
                                                .foregroundColor(Color("DefaultTextColor"))
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                rocksViewModel.toggleFavorite(rock: rock)
                                            }) {
                                                Image(systemName: rocksViewModel.isFavorite(rock: rock) ? "heart.fill" : "heart")
                                                    .foregroundColor(rocksViewModel.isFavorite(rock: rock) ? .red : .gray)
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .padding(.vertical, 6)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                                        .shadow(radius: 3)
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color("BackgroundColor"))
                        .refreshable {
                            rocksViewModel.fetchRocks()
                        }
                    }
                }
                .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
                .navigationTitle("Rocks List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showingAddRock = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(Color("ButtonDefault"))
                        }
                        .sheet(isPresented: $showingAddRock) {
                            AddRockView()
                                .environmentObject(rocksViewModel)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 20) {
                            Button(action: {
                                showingSettings.toggle()
                            }) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(Color("ButtonDefault"))
                            }
                            .sheet(isPresented: $showingSettings) {
                                SettingsView()
                            }
                            
                            Button(action: {
                                showingAccountSettings.toggle()
                            }) {
                                Image(systemName: "person.circle")
                                    .foregroundColor(Color("ButtonDefault"))
                            }
                            .sheet(isPresented: $showingAccountSettings) {
                                AccountSettingsView()
                            }
                            
                            Button(action: {
                                authViewModel.signOut()
                            }) {
                                Image(systemName: "power")
                                    .foregroundColor(Color("ButtonDefault"))
                            }
                        }
                    }
                }
                .onAppear {
                    rocksViewModel.fetchRocks()
                }
            }
        }
    }
}
