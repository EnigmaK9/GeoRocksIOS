// SettingsViewModel.swift
// GeoRocksIOS

import Foundation
import Combine

// Import the UserServiceProtocol from UserService.swift.
// Ensure that UserService.swift is part of the project and correctly linked.
// For example:
import GeoRocksIOS // Replace with your actual module name if different.

// The SettingsViewModel conforms to ObservableObject to allow SwiftUI views to observe changes.
class SettingsViewModel: ObservableObject {
    // UserService is injected to handle user-related operations.
    private var userService: UserServiceProtocol
    
    // Published properties for settings can be added here.
    @Published var isDarkMode: Bool = false
    @Published var fontSize: Double = 16.0
    @Published var highContrast: Bool = false
    
    // Additional settings-related properties can be declared here.
    
    // The initializer injects the UserService, defaulting to the shared instance.
    init(userService: UserServiceProtocol = UserService.shared) {
        self.userService = userService
        // Additional initialization can be performed here.
    }
    
    // Example function to update user profile.
    func updateUserProfile(name: String, email: String) {
        userService.updateProfile(name: name, email: email) { [weak self] result in
            switch result {
            case .success():
                // Handle successful profile update.
                print("Profile updated successfully.")
            case .failure(let error):
                // Handle errors during profile update.
                print("Error updating profile: \(error.localizedDescription)")
            }
        }
    }
    
    // Example function to change password.
    func changePassword(oldPassword: String, newPassword: String) {
        userService.changePassword(oldPassword: oldPassword, newPassword: newPassword) { [weak self] result in
            switch result {
            case .success():
                // Handle successful password change.
                print("Password changed successfully.")
            case .failure(let error):
                // Handle errors during password change.
                print("Error changing password: \(error.localizedDescription)")
            }
        }
    }
    
    // Additional settings-related functions can be implemented here.
}
