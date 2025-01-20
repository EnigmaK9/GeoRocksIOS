// GeoRocksIOSApp.swift
// -----------------------------------------------------------
// GeoRocksIOSApp.swift (Updated with additional tabs)
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file configures the main SwiftUI App. It now displays
// a TabView for authenticated users, combining RocksListView,
// FeatureLauncherView, GraphsView, and FavoritesView.
// -----------------------------------------------------------

import SwiftUI
import Firebase

@main
struct GeoRocksIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var rocksViewModel = RocksViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var accountSettingsViewModel = AccountSettingsViewModel()

    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var isLoading: Bool = true

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingView()
                        .onAppear {
                            authViewModel.checkAuthenticationStatus { _ in
                                isLoading = false
                            }
                        }
                }
                else if authViewModel.isLoggedIn {
                    // A tab-based approach merges multiple views:
                    TabView {
                        // First Tab: RocksListView
                        RocksListView()
                            .environmentObject(authViewModel)
                            .environmentObject(rocksViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(accountSettingsViewModel)
                            .tabItem {
                                Label("Rocks", systemImage: "list.bullet")
                            }

                        // Second Tab: FeatureLauncherView for additional features
                        FeatureLauncherView()
                            .environmentObject(authViewModel)
                            .environmentObject(rocksViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(accountSettingsViewModel)
                            .tabItem {
                                Label("Features", systemImage: "star.fill")
                            }

                        // Third Tab: GraphsView to display data graphs
                        GraphsView()
                            .environmentObject(rocksViewModel)
                            .tabItem {
                                Label("Graphs", systemImage: "chart.bar")
                            }

                        // Fourth Tab: FavoritesView to display favorited rocks
                        FavoritesView()
                            .environmentObject(rocksViewModel)
                            .tabItem {
                                Label("Favorites", systemImage: "heart.fill")
                            }
                    }
                }
                else {
                    NavigationView {
                        LoginView()
                            .environmentObject(authViewModel)
                            .environmentObject(rocksViewModel)
                            .environmentObject(settingsViewModel)
                            .environmentObject(accountSettingsViewModel)
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .alert(isPresented: Binding<Bool>(
                get: { authViewModel.errorMessage != nil },
                set: { _ in authViewModel.errorMessage = nil }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(authViewModel.errorMessage ?? "An unknown error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// The LoadingView remains unchanged.
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                .scaleEffect(1.5)
                .padding()
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
}
