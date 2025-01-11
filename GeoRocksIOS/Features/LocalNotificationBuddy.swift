// -----------------------------------------------------------
// LocalNotificationBuddy.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file shows how to schedule local notifications using
// UNUserNotificationCenter. A time interval is specified, and the
// user receives a notification after that delay.
// -----------------------------------------------------------

import SwiftUI
import UserNotifications

/// LocalNotificationManager provides a function to schedule local notifications.
class LocalNotificationManager: ObservableObject {
    /// A local notification is scheduled with the specified title, body,
    /// and time interval. An alert sound is included by default.
    func scheduleNotification(title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling local notification: \(error.localizedDescription)")
            }
        }
    }
}

/// A SwiftUI view that includes a button to schedule a simple test notification.
struct LocalNotificationExampleView: View {
    var manager = LocalNotificationManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Local Notification Buddy")
                .font(.title)
            
            Button("Schedule Notification (5s)") {
                manager.scheduleNotification(
                    title: "Reminder",
                    body: "Check out the new updates!",
                    timeInterval: 5
                )
            }
        }
        .padding()
    }
}
