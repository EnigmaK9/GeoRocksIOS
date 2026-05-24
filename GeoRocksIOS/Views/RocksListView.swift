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
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    // Custom search and filter panel
                    VStack(spacing: 12) {
                        // Premium Custom Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray.opacity(0.8))
                            
                            TextField("Buscar especímenes...", text: $searchText)
                                .foregroundColor(Color("DefaultTextColor"))
                                .font(.body)
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color("BoxBackground").opacity(0.8))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        .padding(.horizontal)
                        
                        // Premium Segmented Picker
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .onChange(of: sortOption) { _ in
                            rocksViewModel.sortRocks(option: sortOption)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(Color("BackgroundColor"))
                    
                    if rocksViewModel.isLoading {
                        Spacer()
                        VStack(spacing: 16) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                .scaleEffect(1.5)
                            Text("Cargando catálogo...")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else if let errorMessage = rocksViewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        Spacer()
                    } else {
                        // Premium Card ScrollView
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(rocksViewModel.filteredAndSortedRocks(searchText: searchText)) { rock in
                                    NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                                        RockCardView(
                                            rock: rock,
                                            isFavorite: rocksViewModel.isFavorite(rock: rock),
                                            onFavoriteToggle: {
                                                rocksViewModel.toggleFavorite(rock: rock)
                                            }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 30)
                        }
                        .refreshable {
                            rocksViewModel.fetchRocks()
                        }
                    }
                }
            }
            .navigationTitle("GeoRocks UNAM")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingAddRock = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("ButtonDefault"))
                    }
                    .sheet(isPresented: $showingAddRock) {
                        AddNewRockView()
                            .environmentObject(rocksViewModel)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.body)
                                .foregroundColor(Color("ButtonDefault"))
                        }
                        .sheet(isPresented: $showingSettings) {
                            SettingsView()
                        }
                        
                        Button(action: {
                            showingAccountSettings.toggle()
                        }) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.title3)
                                .foregroundColor(Color("ButtonDefault"))
                        }
                        .sheet(isPresented: $showingAccountSettings) {
                            AccountSettingsView()
                                .environmentObject(accountSettingsViewModel)
                                .environmentObject(authViewModel)
                        }
                        
                        Button(action: {
                            authViewModel.signOut()
                        }) {
                            Image(systemName: "power.circle.fill")
                                .font(.title3)
                                .foregroundColor(.red.opacity(0.8))
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

struct RockCardView: View {
    let rock: RockDto
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Async Thumbnail Image
            if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                            .frame(width: 80, height: 80)
                            .background(Color("CoffeeBackground").opacity(0.3))
                            .cornerRadius(12)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(12)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.6))
                            .frame(width: 80, height: 80)
                            .background(
                                LinearGradient(
                                    colors: [Color("ButtonDefault").opacity(0.6), Color("CoffeeBackground")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(12)
                    @unknown default:
                        Color.gray
                            .frame(width: 80, height: 80)
                            .cornerRadius(12)
                    }
                }
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            } else {
                Image(systemName: "circle.grid.cross.fill")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 80, height: 80)
                    .background(
                        LinearGradient(
                            colors: [Color("ButtonDefault").opacity(0.6), Color("CoffeeBackground")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(rock.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("DefaultTextColor"))
                    .lineLimit(1)
                
                // Badges for Cut/ThinSection
                HStack(spacing: 6) {
                    if rock.cut == true {
                        Text("Corte")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color("ButtonDefault").opacity(0.15))
                            .foregroundColor(Color("ButtonDefault"))
                            .cornerRadius(6)
                    }
                    if rock.thinSection == true {
                        Text("Lámina")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.blue.opacity(0.15))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                    }
                    
                    if let locality = rock.locationName {
                        Text(locality)
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            // Favorite Button
            Button(action: onFavoriteToggle) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(isFavorite ? .red : .gray.opacity(0.6))
                    .scaleEffect(isFavorite ? 1.15 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isFavorite)
                    .padding(8)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BoxBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.12), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}
