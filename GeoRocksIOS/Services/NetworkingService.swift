//
//  NetworkingService.swift
//  GeoRocksIOS
//
//  Created by Carlos Padilla on 12/12/2024.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case noData
}

class NetworkingService {
    
    static let shared = NetworkingService()
    private init() { }
    
    func fetchRockList(completion: @escaping (Result<[RockDto], Error>) -> Void) {
        guard let url = URL(string: "https://api.backend.com/rocks/rock_list") else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkingError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode([RockDto].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
