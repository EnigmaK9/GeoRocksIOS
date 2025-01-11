// -----------------------------------------------------------
//  RocksViewModel.swift
//  GeoRocksIOS
//  Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
//  Description:
//  This ViewModel manages a list of RockDto objects, providing
//  both local disk persistence (via DiskCacheManagerV2) and
//  remote fetching (via NetworkingService). Favorite rock IDs
//  are stored in UserDefaults, and sorting or filtering is
//  supported. Loading states and error messages are also handled.
// -----------------------------------------------------------

import SwiftUI
import Combine

/// Sorting options for rocks by title.
enum SortOption: String, CaseIterable, Identifiable {
    case ascending = "A-Z"
    case descending = "Z-A"
    
    var id: String { self.rawValue }
}

/// The main ViewModel that manages rock data, local persistence, remote fetching, sorting, and favorites.
class RocksViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Holds the list of rocks.
    @Published var rocks: [RockDto] = []
    
    /// Indicates a loading or network request in progress.
    @Published var isLoading: Bool = false
    
    /// Stores error messages for UI presentation.
    @Published var errorMessage: String?
    
    /// Stores IDs of favorite rocks.
    @Published var favoriteRockIDs: Set<String> = []
    
    // MARK: - Internal Properties
    
    /// Used for any future Combine subscriptions (if needed).
    private var cancellables = Set<AnyCancellable>()
    
    /// Key used for saving and loading favoriteRockIDs in UserDefaults.
    private let favoritesKey = "FavoriteRockIDs"
    
    // MARK: - Initializer
    
    /// Initializes the ViewModel by loading favorites from UserDefaults and attempting to load stored rocks from disk.
    init() {
        loadFavorites()   // Load favorite IDs from UserDefaults
        loadFromDisk()    // Load rocks from local storage if available
    }
    
    // MARK: - Local Persistence
    
    /// Saves the current array of rocks to disk using DiskCacheManagerV2.
    func saveToDisk() {
        do {
            try DiskCacheManagerV2.shared.saveRocks(rocks)
        } catch {
            print("An error occurred while saving rocks: \(error.localizedDescription)")
        }
    }
    
    /// Loads the array of rocks from local storage if a file exists.
    func loadFromDisk() {
        do {
            let loaded = try DiskCacheManagerV2.shared.loadRocks()
            self.rocks = loaded
        } catch {
            print("Rocks could not be loaded from disk or file not found: \(error.localizedDescription)")
        }
    }
    
    /// Adds a new rock to the list and immediately saves to disk.
    func addRock(_ rock: RockDto) {
        rocks.append(rock)
        saveToDisk()
    }
    
    // MARK: - Remote Fetch
    
    /// Fetches the list of rocks from the backend API.
    /// Any existing data is overwritten, and the loaded array is also saved locally for offline use.
    func fetchRocks() {
        isLoading = true
        errorMessage = nil
        
        NetworkingService.shared.fetchRockList { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(let fetchedRocks):
                    self.rocks = fetchedRocks
                    self.saveToDisk()  // Save fetched data locally
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching rocks: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Sorting and Filtering
    
    /// Sorts the rocks in ascending or descending order by title.
    func sortRocks(option: SortOption) {
        switch option {
        case .ascending:
            rocks.sort { $0.title.lowercased() < $1.title.lowercased() }
        case .descending:
            rocks.sort { $0.title.lowercased() > $1.title.lowercased() }
        }
    }
    
    /// Returns rocks filtered by a search text (case-insensitive match in the title).
    /// More complex sorting could also be applied if needed.
    func filteredAndSortedRocks(searchText: String) -> [RockDto] {
        rocks.filter { rock in
            searchText.isEmpty || rock.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    // MARK: - Favorites
    
    /// Toggles the favorite status of a specific rock. The local Set is updated, and changes are saved to UserDefaults.
    func toggleFavorite(rock: RockDto) {
        if favoriteRockIDs.contains(rock.id) {
            favoriteRockIDs.remove(rock.id)
        } else {
            favoriteRockIDs.insert(rock.id)
        }
        saveFavorites()
    }
    
    /// Checks if a rock is currently marked as favorite.
    func isFavorite(rock: RockDto) -> Bool {
        favoriteRockIDs.contains(rock.id)
    }
    
    /// Loads the set of favorite rock IDs from UserDefaults.
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteRockIDs = Set(savedFavorites)
        }
    }
    
    /// Saves the current set of favorite rock IDs to UserDefaults.
    private func saveFavorites() {
        let favoritesArray = Array(favoriteRockIDs)
        UserDefaults.standard.set(favoritesArray, forKey: favoritesKey)
    }
}
