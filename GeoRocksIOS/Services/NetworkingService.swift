//
//  NetworkingService.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import Foundation

enum NetworkingError: Error, LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case httpError(Int) // Associated value for HTTP status code
    case decodingError(String) // Associated value for decoding message
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let statusCode):
            return "HTTP Code Error: \(statusCode)"
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        }
    }
}

class NetworkingService {
    
    // Singleton instance for global access
    static let shared = NetworkingService()
    
    // Private initializer to prevent multiple instances
    private init() { }
    
    /// Fetches the list of rocks from the backend.
    /// - Parameter completion: Completion handler with Result containing an array of RockDto or an Error.
    func fetchRockList(completion: @escaping (Result<[RockDto], Error>) -> Void) {
        // Updated Base URL to match Apiary mock server
        guard let url = URL(string: "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_list") else {
            completion(.failure(NetworkingError.invalidURL))
            print("Invalid URL: https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_list")
            return
        }
        
        // Initiate data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle network errors
            if let error = error {
                completion(.failure(error))
                print("Network Error: \(error.localizedDescription)")
                return
            }
            
            // Check for valid HTTP response and status code
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkingError.httpError(httpResponse.statusCode)))
                    print("HTTP Error with status code: \(httpResponse.statusCode)")
                    return
                }
            } else {
                completion(.failure(NetworkingError.invalidResponse))
                print("Invalid response from the server.")
                return
            }
            
            // Ensure data is received
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                print("No data received from the server.")
                return
            }
            
            do {
                // Decode JSON data into an array of RockDto
                let decoded = try JSONDecoder().decode([RockDto].self, from: data)
                completion(.success(decoded))
            } catch {
                // Handle decoding errors with detailed messages
                completion(.failure(NetworkingError.decodingError(error.localizedDescription)))
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
        
        // Start the network request
        task.resume()
    }
    
    /// Fetches detailed information about a specific rock using its ID.
    /// - Parameters:
    ///   - rockId: The unique identifier of the rock.
    ///   - completion: Completion handler with Result containing RockDetailDto or an Error.
    func fetchRockDetail(rockId: String, completion: @escaping (Result<RockDetailDto, Error>) -> Void) {
        // Updated Base URL to match Apiary mock server
        let urlString = "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_detail/\(rockId)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.invalidURL))
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Initiate data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Handle network errors
            if let error = error {
                completion(.failure(error))
                print("Network Error: \(error.localizedDescription)")
                return
            }
            
            // Check for valid HTTP response and status code
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkingError.httpError(httpResponse.statusCode)))
                    print("HTTP Error with status code: \(httpResponse.statusCode)")
                    return
                }
            } else {
                completion(.failure(NetworkingError.invalidResponse))
                print("Invalid response from the server.")
                return
            }
            
            // Ensure data is received
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                print("No data received from the server.")
                return
            }
            
            do {
                // Decode JSON data into RockDetailDto
                let decoded = try JSONDecoder().decode(RockDetailDto.self, from: data)
                completion(.success(decoded))
            } catch {
                // Handle decoding errors with detailed messages
                completion(.failure(NetworkingError.decodingError(error.localizedDescription)))
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
        
        // Start the network request
        task.resume()
    }
}
