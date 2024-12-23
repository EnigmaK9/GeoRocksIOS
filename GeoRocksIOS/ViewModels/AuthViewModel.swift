//
//  AuthViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        // Check if a user is already signed in at app launch
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.isLoggedIn = true
            }
        }
    }
    
    // MARK: - Register (Create New Account)
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error registering: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self?.isLoggedIn = true
            }
        }
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset: \(error.localizedDescription)")
            } else {
                print("Password reset email sent to \(email)")
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
