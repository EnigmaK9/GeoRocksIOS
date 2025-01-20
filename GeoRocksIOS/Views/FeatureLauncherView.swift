// -----------------------------------------------------------
// FeatureLauncherView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file provides a professional SwiftUI view that demonstrates
// various features such as push notifications, local notifications,
// in-app purchases, analytics, theme toggling, voiceover,
// and biometric authentication. It is referenced by
// GeoRocksIOSApp in a TabView for authenticated users.
// -----------------------------------------------------------

import SwiftUI

struct FeatureLauncherView: View {
    // Simple local states to track whether certain features have been triggered.
    @State private var pushTriggered = false
    @State private var localNotifScheduled = false
    @State private var iapFetched = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    // Trigger push authorization once.
                    if !pushTriggered {
                        Button(action: {
                            PushNotificationManager.shared.requestAuthorization()
                            pushTriggered = true
                            alertMessage = "Push notifications authorized!"
                            showAlert = true
                        }) {
                            Label("Request Push Authorization", systemImage: "bell.fill")
                        }
                    }
                    
                    // Schedule a local notification if not done yet.
                    if !localNotifScheduled {
                        Button(action: {
                            let manager = LocalNotificationManager()
                            manager.scheduleNotification(
                                title: "Hello from LocalNotificationBuddy",
                                body: "5 seconds delayed notification!",
                                timeInterval: 5
                            )
                            localNotifScheduled = true
                            alertMessage = "Local notification scheduled!"
                            showAlert = true
                        }) {
                            Label("Schedule Local Notification", systemImage: "alarm")
                        }
                    }
                }
                
                Section(header: Text("In-App Features")) {
                    // Fetch IAP products once, for demonstration.
                    if !iapFetched {
                        Button(action: {
                            IAPManager.shared.fetchProducts(productIDs: ["com.yourapp.exampleitem"])
                            iapFetched = true
                            alertMessage = "In-app products fetched!"
                            showAlert = true
                        }) {
                            Label("Fetch IAP Products", systemImage: "cart.fill")
                        }
                    }

                    // Toggle theme on demand.
                    Button(action: {
                        ThemeManager.shared.toggleTheme()
                        alertMessage = "Theme toggled!"
                        showAlert = true
                    }) {
                        Label("Toggle Theme", systemImage: "paintbrush")
                    }
                }

                Section(header: Text("Accessibility Features")) {
                    // Link to VoiceOverChampion (AccessibilityExampleView).
                    NavigationLink(destination: AccessibilityExampleView()) {
                        Label("VoiceOver Demo", systemImage: "accessibility")
                    }

                    // Test biometric authentication.
                    Button(action: {
                        BiometricAuthManager.shared.authenticateUser { success, errorMessage in
                            DispatchQueue.main.async {
                                if success {
                                    alertMessage = "Biometric Auth Success!"
                                } else {
                                    alertMessage = "Biometric Auth Failed: \(errorMessage ?? "Unknown error")"
                                }
                                showAlert = true
                            }
                        }
                    }) {
                        Label("Test Biometric Auth", systemImage: "faceid")
                    }
                }
            }
            .navigationTitle("Feature Launcher")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Notification"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct FeatureLauncherView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureLauncherView()
    }
}
