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

struct CreateSampleRequest: Codable {
    let rock_name: String
    let rock_description: String
    let location_name: String
    let location_country: String
    let cut: Bool
    let thin_section: Bool
    let picture: String
}

class NetworkingService {
    
    // Singleton instance for global access
    static let shared = NetworkingService()
    
    // Private initializer to prevent multiple instances
    private init() { }
    
    private let tokenKey = "GeoRocksJWTToken"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    private func authenticatedRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    /// Registers a new rock specimen on the remote FastAPI server.
    func createRockSample(name: String, description: String, location: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.1.64:8003/samples/") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let requestBody = CreateSampleRequest(
            rock_name: name,
            rock_description: description,
            location_name: location,
            location_country: "México",
            cut: false,
            thin_section: false,
            picture: "Sin muestra"
        )
        
        var request = authenticatedRequest(url: url, method: "POST")
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(NetworkingError.httpError(httpResponse.statusCode)))
                    return
                }
                completion(.success(()))
            } else {
                completion(.failure(NetworkingError.invalidResponse))
            }
        }
        task.resume()
    }
    
    /// Fetches the list of rocks from the backend.
    /// - Parameter completion: Completion handler with Result containing an array of RockDto or an Error.
    func fetchRockList(completion: @escaping (Result<[RockDto], Error>) -> Void) {
        // Updated Base URL to match local FastAPI server
        guard let url = URL(string: "http://192.168.1.64:8003/samples/") else {
            completion(.failure(NetworkingError.invalidURL))
            print("Invalid URL: http://192.168.1.64:8003/samples/")
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
        // Updated Base URL to match local FastAPI server
        let urlString = "http://192.168.1.64:8003/samples/\(rockId)"
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
