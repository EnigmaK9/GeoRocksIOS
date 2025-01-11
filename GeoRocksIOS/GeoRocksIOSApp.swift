// GeoRocksIOSApp.swift
// GeoRocksIOS

import SwiftUI
import Firebase

@main
struct GeoRocksIOSApp: App {
    // The AppDelegate is registered to handle Firebase configuration.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // The AuthViewModel is instantiated and observed for authentication state changes.
    @StateObject private var authViewModel = AuthViewModel()
    
    // The RocksViewModel is instantiated and observed for managing rocks data.
    @StateObject private var rocksViewModel = RocksViewModel()
    
    // The SettingsViewModel is instantiated and observed for managing app settings.
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    // The AccountSettingsViewModel is instantiated and observed for managing account settings.
    @StateObject private var accountSettingsViewModel = AccountSettingsViewModel()
    
    // The user's theme preference is accessed and stored using @AppStorage for persistence.
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    // A state variable to manage the loading state during authentication checks.
    @State private var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            // A group is used to handle different view states based on authentication status.
            Group {
                // If the app is currently loading (e.g., checking authentication status), a loading view is displayed.
                if isLoading {
                    LoadingView()
                        .onAppear {
                            // The authentication status is verified when the loading view appears.
                            authViewModel.checkAuthenticationStatus { authenticated in
                                // The loading state is updated based on the authentication result.
                                isLoading = false
                            }
                        }
                }
                // If the user is authenticated, the main RocksListView is displayed.
                else if authViewModel.isLoggedIn {
                    RocksListView()
                        // Environment objects are provided to the RocksListView for data management.
                        .environmentObject(authViewModel)
                        .environmentObject(rocksViewModel)
                        .environmentObject(settingsViewModel) // Provides SettingsViewModel
                        .environmentObject(accountSettingsViewModel) // Provides AccountSettingsViewModel
                }
                // If the user is not authenticated, the LoginView is displayed.
                else {
                    NavigationView {
                        LoginView()
                            // Environment objects are provided to the LoginView for authentication handling.
                            .environmentObject(authViewModel)
                            .environmentObject(rocksViewModel)
                            .environmentObject(settingsViewModel) // Provides SettingsViewModel
                            .environmentObject(accountSettingsViewModel) // Provides AccountSettingsViewModel
                    }
                }
            }
            // The preferred color scheme is set based on the user's theme preference.
            .preferredColorScheme(isDarkMode ? .dark : .light)
            // An alert is presented if there is an error during authentication status check.
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

/// A simple loading view displayed while authentication status is being verified.
struct LoadingView: View {
    var body: some View {
        VStack {
            // A progress indicator is shown to inform the user that a process is ongoing.
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                .scaleEffect(1.5)
                .padding()
        }
        // The background color is set to match the app's theme.
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }
}

/// A preview provider for the GeoRocksIOSApp.
struct GeoRocksIOSApp_Previews: PreviewProvider {
    static var previews: some View {
        RocksListView()
            .environmentObject(AuthViewModel()) // Provides a mock AuthViewModel.
            .environmentObject(RocksViewModel()) // Provides a mock RocksViewModel.
            .environmentObject(SettingsViewModel()) // Provides a mock SettingsViewModel.
            .environmentObject(AccountSettingsViewModel()) // Provides a mock AccountSettingsViewModel.
    }
}
