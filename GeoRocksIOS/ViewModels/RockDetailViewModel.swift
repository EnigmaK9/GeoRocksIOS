//
//  RockDetailViewModel.swift
//  GeoRocksIOS
//
//  Author: Carlos Padilla
//  Date: 12/12/2024
//
//  Description:
//  This file provides a ViewModel for fetching detailed rock information
//  from a remote API. A published property holds the retrieved details,
//  while loading and error states are handled accordingly in passive voice.
//
import Foundation

class RockDetailViewModel: ObservableObject {
    // A published property is used to store the detailed information of a rock.
    @Published var rockDetail: RockDetailDto?
    
    // A published property is used to indicate whether data is being loaded.
    @Published var isLoading: Bool = false
    
    // A published property is used to store any error messages encountered during data fetching.
    @Published var error: String?

    // A function is used to fetch the details of a specific rock by its ID.
    func fetchRockDetail(rockId: String) {
        // The URL is constructed using the specified rockId.
        let urlString = "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_detail/\(rockId)"
        
        // A check is done to ensure the URL is valid.
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                // The error message is assigned if the URL is invalid.
                self.error = "Invalid URL: \(urlString)"
            }
            print("Invalid URL: \(urlString)")
            return
        }
        
        // The loading state is set to true before initiating the network request.
        self.isLoading = true
        self.error = nil
        
        // A data task is created to fetch data from the specified URL.
        URLSession.shared.dataTask(with: url) { [weak self] data, response, fetchError in
            DispatchQueue.main.async {
                // The loading state is set to false after a response is received.
                self?.isLoading = false
            }
            
            // A network error check is performed.
            if let fetchError = fetchError {
                DispatchQueue.main.async {
                    // A network error message is assigned if an issue occurs.
                    self?.error = "Network Error: \(fetchError.localizedDescription)"
                }
                print("Error fetching rock detail: \(fetchError.localizedDescription)")
                return
            }
            
            // A check is performed to ensure data is received.
            guard let data = data else {
                DispatchQueue.main.async {
                    // An error message is assigned if data is missing.
                    self?.error = "No data received."
                }
                print("No data returned for rock detail.")
                return
            }
            
            do {
                // The JSON data is decoded into a RockDetailDto object.
                let decoded = try JSONDecoder().decode(RockDetailDto.self, from: data)
                DispatchQueue.main.async {
                    // The decoded rock detail is assigned to the rockDetail property.
                    self?.rockDetail = decoded
                }
            } catch let decodingError {
                DispatchQueue.main.async {
                    // A data decoding error message is assigned if an exception occurs.
                    self?.error = "Data Decoding Error: \(decodingError.localizedDescription)"
                }
                print("Error decoding rock detail: \(decodingError.localizedDescription)")
            }
        }
        .resume() // The data task is started.
    }
}
