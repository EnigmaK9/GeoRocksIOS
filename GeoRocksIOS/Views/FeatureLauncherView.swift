// -----------------------------------------------------------
// FeatureLauncherView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file provides a simple SwiftUI view that demonstrates
// features 4-10 (push notifications, local notifications,
// in-app purchases, analytics, theme toggling, voiceover,
// and biometric authentication). It is referenced by
// GeoRocksIOSApp in a TabView for authenticated users.
// -----------------------------------------------------------

import SwiftUI

struct FeatureLauncherView: View {
    // Simple local states to track whether certain features have been triggered.
    @State private var pushTriggered = false
    @State private var localNotifScheduled = false
    @State private var iapFetched = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Feature Launcher")
                .font(.title)
                .padding()
            
            // Trigger push authorization once.
            if !pushTriggered {
                Button("Request Push Authorization") {
                    PushNotificationManager.shared.requestAuthorization()
                    pushTriggered = true
                }
            }
            
            // Fetch IAP products once, for demonstration.
            if !iapFetched {
                Button("Fetch IAP Products") {
                    IAPManager.shared.fetchProducts(productIDs: ["com.yourapp.exampleitem"])
                    iapFetched = true
                }
            }
            
            // Toggle theme on demand.
            Button("Toggle Theme") {
                ThemeManager.shared.toggleTheme()
            }
            
            // Link to VoiceOverChampion (AccessibilityExampleView).
            NavigationLink(destination: AccessibilityExampleView()) {
                Text("VoiceOver Demo")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Schedule a local notification if not done yet.
            if !localNotifScheduled {
                Button("Schedule Local Notification") {
                    let manager = LocalNotificationManager()
                    manager.scheduleNotification(
                        title: "Hello from LocalNotificationBuddy",
                        body: "5 seconds delayed notification!",
                        timeInterval: 5
                    )
                    localNotifScheduled = true
                }
            }
            
            // Test biometric authentication.
            Button("Test Biometric Auth") {
                BiometricAuthManager.shared.authenticateUser { success, errorMessage in
                    if success {
                        print("Biometric Auth Success!")
                    } else {
                        print("Biometric Auth Failed: \(errorMessage ?? "Unknown error")")
                    }
                }
            }
        }
        .padding()
        // An analytics event is logged when this view appears.
        .onAppear {
            AnalyticsManager.shared.logEvent(
                name: "FeatureLauncherView_Opened",
                parameters: ["screen": "FeatureLauncher"]
            )
        }
    }
}
