// UserService.swift
// GeoRocksIOS

import Foundation
import Combine

// Protocol is defined once to outline user-related network requests.
protocol UserServiceProtocol {
    func updateProfile(name: String, email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
    // The deleteAccount method has been removed as per user request.
}

// Implementation of UserServiceProtocol.
class UserService: UserServiceProtocol {
    static let shared = UserService()
    
    private init() {}
    
    func updateProfile(name: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implementation of profile update.
        // Simulated network delay.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Assuming the update is successful.
            completion(.success(()))
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Implementation of password change.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            // Assuming the password change is successful.
            completion(.success(()))
        }
    }
    
    // The deleteAccount method has been removed to comply with user request.
}
