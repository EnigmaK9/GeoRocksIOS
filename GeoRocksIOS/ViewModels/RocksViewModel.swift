// RocksViewModel.swift
// GeoRocksIOS

import SwiftUI
import Combine

// Enum is defined outside to ensure accessibility across different ViewModels and Views.
enum SortOption: String, CaseIterable, Identifiable {
    case ascending = "A-Z"
    case descending = "Z-A"
    
    var id: String { self.rawValue }
}

class RocksViewModel: ObservableObject {
    @Published var rocks: [RockDto] = [] // Published property to store the list of rocks
    @Published var isLoading: Bool = false // Published property to indicate loading state
    @Published var errorMessage: String? // Published property to store error messages
    
    // Published property to store favorite rock IDs
    @Published var favoriteRockIDs: Set<String> = [] // Set is used for efficient lookup
    
    private var cancellables = Set<AnyCancellable>() // Set to store Combine subscriptions
    
    // Key used for storing favoriteRockIDs in UserDefaults
    private let favoritesKey = "FavoriteRockIDs"
    
    /// Initializes the ViewModel by loading favorites from UserDefaults.
    init() {
        loadFavorites()
    }
    
    /// Fetches the list of rocks from the backend.
    func fetchRocks() {
        isLoading = true
        errorMessage = nil
        
        NetworkingService.shared.fetchRockList { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let rocks):
                    self?.rocks = rocks
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Error fetching rocks: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Sorts the rocks based on the selected sort option.
    /// - Parameter option: The selected SortOption.
    func sortRocks(option: SortOption) {
        switch option {
        case .ascending:
            rocks.sort { $0.title.lowercased() < $1.title.lowercased() }
        case .descending:
            rocks.sort { $0.title.lowercased() > $1.title.lowercased() }
        }
    }
    
    /// Filters and sorts the rocks based on the search text.
    /// - Parameter searchText: The text entered by the user for searching.
    /// - Returns: A filtered and sorted array of RockDto.
    func filteredAndSortedRocks(searchText: String) -> [RockDto] {
        let filtered = rocks.filter { rock in
            searchText.isEmpty || rock.title.lowercased().contains(searchText.lowercased())
        }
        
        return filtered
    }
    
    /// Toggles the favorite status of a given rock.
    /// - Parameter rock: The RockDto object to be favorited or unfavorited.
    func toggleFavorite(rock: RockDto) {
        if favoriteRockIDs.contains(rock.id) {
            favoriteRockIDs.remove(rock.id)
        } else {
            favoriteRockIDs.insert(rock.id)
        }
        saveFavorites()
    }
    
    /// Checks if a given rock is marked as favorite.
    /// - Parameter rock: The RockDto object to check.
    /// - Returns: A Boolean indicating whether the rock is a favorite.
    func isFavorite(rock: RockDto) -> Bool {
        favoriteRockIDs.contains(rock.id)
    }
    
    /// Loads favoriteRockIDs from UserDefaults.
    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteRockIDs = Set(savedFavorites)
        }
    }
    
    /// Saves favoriteRockIDs to UserDefaults.
    private func saveFavorites() {
        let favoritesArray = Array(favoriteRockIDs)
        UserDefaults.standard.set(favoritesArray, forKey: favoritesKey)
    }
}
