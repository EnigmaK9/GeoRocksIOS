//
//  GeoRocksIOSApp.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//

import SwiftUI
import Firebase

@main
struct GeoRocksIOSApp: App {
    // Create and own an AuthViewModel instance
    @StateObject var authViewModel = AuthViewModel()

    init() {
        // Initialize Firebase here
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            // Check if user is logged in
            if authViewModel.isLoggedIn {
                // Show MainRocksView (or any screen for logged-in users)
                MainRocksView()
                    .environmentObject(authViewModel)
            } else {
                // Otherwise, display LoginView
                NavigationView {
                    LoginView()
                }
                .environmentObject(authViewModel)
            }
        }
    }
}
