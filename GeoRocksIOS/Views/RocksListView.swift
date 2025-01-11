// -----------------------------------------------------------
// RocksListView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file displays a list of rocks fetched from a remote source.
// It allows sorting, searching, and toggling favorites. The local
// cache engine is also integrated for offline capabilities.
// -----------------------------------------------------------

import SwiftUI

struct RocksListView: View {
    // These @EnvironmentObjects provide data and state from shared ViewModels.
    @EnvironmentObject var rocksViewModel: RocksViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var accountSettingsViewModel: AccountSettingsViewModel
    
    // These @State properties manage UI states, including search text and sort options.
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .ascending
    @State private var showingSettings = false
    @State private var showingAccountSettings = false
    @State private var showingAddRock = false
    
    // This property provides feedback about caching operations.
    @State private var cacheMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // The main content is grouped to handle loading/error states.
                Group {
                    if rocksViewModel.isLoading {
                        // A progress indicator is displayed while data is being fetched.
                        ProgressView("Loading Rocks...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                            .scaleEffect(1.5)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 5)
                    } else if let errorMessage = rocksViewModel.errorMessage {
                        // An error message is shown if the fetch fails.
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                            .shadow(radius: 5)
                    } else {
                        // A list is displayed if rocks are successfully loaded.
                        List {
                            Section(header: SearchBar(text: $searchText)) {
                                // The user can pick a sort option via segmented control.
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
                                
                                // Filtered and sorted rocks are iterated to display each item.
                                ForEach(rocksViewModel.filteredAndSortedRocks(searchText: searchText)) { rock in
                                    NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                                        HStack(spacing: 12) {
                                            // A thumbnail image is loaded asynchronously, if available.
                                            if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        // A placeholder is shown while the image is loading.
                                                        Color.gray
                                                            .frame(width: 50, height: 50)
                                                            .overlay(
                                                                ProgressView()
                                                                    .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                                            )
                                                    case .success(let image):
                                                        // The loaded image is displayed.
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 50, height: 50)
                                                            .clipped()
                                                    case .failure:
                                                        // A fallback is shown if the image fails to load.
                                                        Color.red
                                                            .frame(width: 50, height: 50)
                                                            .overlay(
                                                                Image(systemName: "photo")
                                                                    .foregroundColor(.white)
                                                            )
                                                    @unknown default:
                                                        // This fallback handles any unknown cases.
                                                        Color.gray
                                                            .frame(width: 50, height: 50)
                                                    }
                                                }
                                                .cornerRadius(8)
                                                .shadow(radius: 3)
                                            } else {
                                                // A gray box is shown if no thumbnail is available.
                                                Color.gray
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(8)
                                                    .shadow(radius: 3)
                                            }
                                            
                                            // The rock's title is shown.
                                            Text(rock.title)
                                                .font(.headline)
                                                .foregroundColor(Color("DefaultTextColor"))
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            
                                            // A heart icon is used to toggle favorites.
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
                        // A pull-to-refresh is added to re-fetch rocks if needed.
                        .refreshable {
                            rocksViewModel.fetchRocks()
                        }
                    }
                }
                .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
                // The list is labeled with a navigation title.
                .navigationTitle("Rocks List")
                .toolbar {
                    // The leading toolbar contains a button to add new rocks locally.
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
                    
                    // The trailing toolbar provides access to settings, account, and sign out.
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
                            // The correct AccountSettingsView is presented here.
                            .sheet(isPresented: $showingAccountSettings) {
                                AccountSettingsView()
                                    .environmentObject(accountSettingsViewModel)
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
                // Rocks are fetched as soon as the view appears.
                .onAppear {
                    rocksViewModel.fetchRocks()
                }
                
                // Offline Cache Engine Buttons are placed at the bottom of the view.
                VStack(spacing: 10) {
                    // This button saves the fetched rocks data to a local JSON file.
                    Button("Save Rocks to Cache") {
                        do {
                            let data = try JSONEncoder().encode(rocksViewModel.rocks)
                            try DiskCacheManager.shared.saveData(data, fileName: "rocksCache.json")
                            cacheMessage = "Rocks saved to local cache."
                        } catch {
                            cacheMessage = "Error caching data: \(error.localizedDescription)"
                        }
                    }
                    
                    // This button loads any cached rocks data if available.
                    Button("Load Rocks from Cache") {
                        do {
                            if let data = try DiskCacheManager.shared.loadData(fileName: "rocksCache.json") {
                                let decoded = try JSONDecoder().decode([RockDto].self, from: data)
                                rocksViewModel.rocks = decoded
                                cacheMessage = "Rocks loaded from cache."
                            } else {
                                cacheMessage = "No cached rocks found."
                            }
                        } catch {
                            cacheMessage = "Error loading cache: \(error.localizedDescription)"
                        }
                    }
                    
                    // A simple text is used to show messages about cache operations.
                    Text(cacheMessage)
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                }
                .padding()
            }
        }
    }
}
