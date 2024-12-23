//
//  RockDetailViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import SwiftUI

/**
 RockDetailViewModel handles fetching the detailed information of a single rock.
 
 - The `rockDetail` published property triggers UI updates in RockDetailView.
 */
class RockDetailViewModel: ObservableObject {
    
    @Published var rockDetail: RockDetailDto?
    
    /**
     Fetches the detail for a specific rock by its ID.
     
     - Parameter rockId: The unique identifier for the rock.
     */
    func fetchRockDetail(rockId: String) {
        let urlString = "https://api.backend.com/rocks/rock_detail/\(rockId)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid rock detail URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching rock detail: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned for rock detail.")
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(RockDetailDto.self, from: data)
                DispatchQueue.main.async {
                    self?.rockDetail = decoded
                }
            } catch {
                print("Error decoding rock detail: \(error.localizedDescription)")
            }
        }.resume()
    }
}
