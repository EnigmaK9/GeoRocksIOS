//
//  GeoRocksIOSApp.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//
//  Description:
//  The main entry point for the GeoRocksIOS application.
//  Initializes Firebase and provides necessary environment objects to the views.
//

import SwiftUI
import Firebase

@main
struct GeoRocksIOSApp: App {
    // Register AppDelegate for Firebase configuration
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Create and own an instance of AuthViewModel
    @StateObject var authViewModel = AuthViewModel()
    
    // Create and own an instance of RocksViewModel
    @StateObject var rocksViewModel = RocksViewModel()
    
    var body: some Scene {
        WindowGroup {
            // Check if the user is authenticated
            if authViewModel.isLoggedIn {
                // Show RocksListView for authenticated users
                RocksListView()
                    .environmentObject(authViewModel)
                    .environmentObject(rocksViewModel) // Provide RocksViewModel to the environment
            } else {
                // Show LoginView for unauthenticated users
                NavigationView {
                    LoginView()
                }
                .environmentObject(authViewModel)
                .environmentObject(rocksViewModel) // Provide RocksViewModel to the environment
            }
        }
    }
}
