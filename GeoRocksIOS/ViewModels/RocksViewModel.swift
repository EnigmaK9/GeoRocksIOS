//
//  RocksViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//
//  Description:
//  The RocksViewModel manages the data and business logic for RocksListView.
//  Sorting and filtering functionalities have been implemented to enhance user experience.
//

import SwiftUI
import Combine

class RocksViewModel: ObservableObject {
    @Published var rocks: [RockDto] = [] // Published property to store the list of rocks
    @Published var isLoading: Bool = false // Published property to indicate loading state
    @Published var errorMessage: String? // Published property to store error messages
    
    private var cancellables = Set<AnyCancellable>() // Set to store Combine subscriptions
    
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
    func sortRocks(option: RocksListView.SortOption) {
        switch option {
        case .ascending:
            rocks.sort { $0.title.lowercased() < $1.title.lowercased() }
        case .descending:
            rocks.sort { $0.title.lowercased() > $1.title.lowercased() }
        }
    }
    
    /// Filters and sorts the rocks based on the search text and selected sort option.
    /// - Parameter searchText: The text entered by the user for searching.
    /// - Returns: A filtered and sorted array of RockDto.
    func filteredAndSortedRocks(searchText: String) -> [RockDto] {
        let filtered = rocks.filter { rock in
            searchText.isEmpty || rock.title.lowercased().contains(searchText.lowercased())
        }
        
        // Determine the current sort option
        // Assuming the sortOption is managed externally and affects the rocks array
        // If additional sorting state is needed, it should be managed here
        
        return filtered
    }
}
