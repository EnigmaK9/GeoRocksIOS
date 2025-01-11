// AccountSettingsViewModel.swift
// GeoRocksIOS

// AccountSettingsViewModel.swift
// GeoRocksIOS

import Foundation
import Combine

class AccountSettingsViewModel: ObservableObject {
    private var userService: UserServiceProtocol
    
    @Published var isUpdatingProfile: Bool = false
    @Published var updateProfileSuccessMessage: String?
    @Published var updateProfileErrorMessage: String?
    
    init(userService: UserServiceProtocol = UserService.shared) {
        self.userService = userService
    }
    
    func updateUserProfile(name: String, email: String) {
        self.isUpdatingProfile = true
        userService.updateProfile(name: name, email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdatingProfile = false
                switch result {
                case .success():
                    self?.updateProfileSuccessMessage = "Profile updated successfully."
                    self?.updateProfileErrorMessage = nil
                case .failure(let error):
                    self?.updateProfileErrorMessage = error.localizedDescription
                    self?.updateProfileSuccessMessage = nil
                }
            }
        }
    }
    
    func clearMessages() {
        updateProfileSuccessMessage = nil
        updateProfileErrorMessage = nil
    }
}
