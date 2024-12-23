//
//  RocksViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI
import Combine

class RocksViewModel: ObservableObject {
    @Published var rocks: [RockDto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
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
}
