//
//  RocksViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

// RocksViewModel.swift
import SwiftUI

class RocksViewModel: ObservableObject {
    @Published var rocks: [RockDto] = []
    
    func fetchRocks() {
        guard let url = URL(string: "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_list") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching rock list: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned for rock list.")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([RockDto].self, from: data)
                DispatchQueue.main.async {
                    self?.rocks = decoded
                }
            } catch {
                print("Error decoding rock list: \(error.localizedDescription)")
            }
        }.resume()
    }
}
