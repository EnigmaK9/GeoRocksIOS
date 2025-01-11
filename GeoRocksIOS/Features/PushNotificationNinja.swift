// -----------------------------------------------------------
// PushNotificationNinja.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file demonstrates how to request and handle push notifications.
// It includes a shared manager class that configures UNUserNotificationCenter
// and listens for incoming notifications.
// -----------------------------------------------------------

import Foundation
import UserNotifications
import SwiftUI

/// PushNotificationManager is used to manage and delegate push notifications.
class PushNotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = PushNotificationManager()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// This function requests user authorization for push notifications.
    /// If granted, remote notifications are registered. Otherwise, an error is printed.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    /// This delegate function is triggered when a notification is tapped.
    /// It prints the userInfo dictionary for demonstration purposes.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("User tapped push notification: \(userInfo)")
        completionHandler()
    }
}

/// This SwiftUI view shows a button that triggers the authorization request.
/// The manager can be called in AppDelegate or any other place as well.
struct PushNotificationExampleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Push Notification Ninja")
                .font(.title)
            
            Button("Request Notification Authorization") {
                PushNotificationManager.shared.requestAuthorization()
            }
        }
        .padding()
    }
}
