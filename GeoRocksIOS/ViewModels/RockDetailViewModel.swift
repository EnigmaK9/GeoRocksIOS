//
//  RockDetailViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import Foundation

class RockDetailViewModel: ObservableObject {
    // A published property to store the detailed information of a rock
    @Published var rockDetail: RockDetailDto?
    
    // A published property to indicate whether data is being loaded
    @Published var isLoading: Bool = false
    
    // A published property to store any error messages encountered during data fetching
    @Published var error: String?

    // A listener handle to manage the authentication state listener (if needed)
    // private var authListenerHandle: AuthStateDidChangeListenerHandle?

    // A function to fetch the details of a specific rock using its ID
    func fetchRockDetail(rockId: String) {
        // The correct URL is ensured to be used
        let urlString = "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_detail/\(rockId)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                // An invalid URL message is assigned to the error property
                self.error = "Invalid URL: \(urlString)"
            }
            print("Invalid URL: \(urlString)")
            return
        }
        
        // The loading state is set to true before initiating the network request
        self.isLoading = true
        self.error = nil
        
        // A data task is initiated to fetch data from the specified URL
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                // The loading state is set to false after receiving a response
                self?.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    // A network error message is assigned to the error property
                    self?.error = "Network Error: \(error.localizedDescription)"
                }
                print("Error fetching rock detail: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    // A data reception error message is assigned to the error property
                    self?.error = "No data received."
                }
                print("No data returned for rock detail.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // The received JSON data is decoded into a RockDetailDto object
                let decoded = try decoder.decode(RockDetailDto.self, from: data)
                DispatchQueue.main.async {
                    // The decoded rock detail is assigned to the rockDetail property
                    self?.rockDetail = decoded
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    // A data decoding error message is assigned to the error property
                    self?.error = "Data Decoding Error: \(decodingError.localizedDescription)"
                }
                print("Error decoding rock detail: \(decodingError.localizedDescription)")
            }
        }.resume()
    }
}
