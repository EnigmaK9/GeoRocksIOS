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
    // Create and own an instance of AuthViewModel
    @StateObject var authViewModel = AuthViewModel()

    init() {
        // Check for the presence of the plist (optional, for debugging)
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            print("GoogleService-Info.plist found at: \(path)")
        } else {
            print("GoogleService-Info.plist not found in the bundle.")
        }
        
        // Initialize Firebase
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            // Check if the user is authenticated
            if authViewModel.isLoggedIn {
                // Show MainRocksView for authenticated users
                MainRocksView()
                    .environmentObject(authViewModel)
            } else {
                // Show LoginView for unauthenticated users
                NavigationView {
                    LoginView()
                }
                .environmentObject(authViewModel)
            }
        }
    }
}
