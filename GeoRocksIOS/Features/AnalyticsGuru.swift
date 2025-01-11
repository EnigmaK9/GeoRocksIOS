// -----------------------------------------------------------
// AnalyticsGuru.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file shows a basic analytics manager that can be used to log events
// and set user properties. It can be extended to incorporate Firebase or
// other third-party analytics solutions.
// -----------------------------------------------------------

import Foundation
import SwiftUI

/// AnalyticsManager logs events and sets user properties for analytics usage.
class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    /// This function logs an analytics event with optional parameters.
    /// It prints the result here, but could be replaced by a real analytics call.
    func logEvent(name: String, parameters: [String: Any]?) {
        print("Analytics Event: \(name), parameters: \(String(describing: parameters))")
    }
    
    /// This function sets a user property, such as "user_type: premium".
    /// In a real situation, this would call the appropriate analytics method.
    func setUserProperty(_ value: String?, forName name: String) {
        print("Set user property \(name) to \(value ?? "")")
    }
}

/// This SwiftUI view provides a small interface to log events and set user properties.
struct AnalyticsExampleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Analytics Guru")
                .font(.title)
            
            Button("Log Analytics Event") {
                AnalyticsManager.shared.logEvent(
                    name: "UserTappedAnalyticsEvent",
                    parameters: ["screen": "AnalyticsExampleView"]
                )
            }
            
            Button("Set User Property") {
                AnalyticsManager.shared.setUserProperty("PremiumUser", forName: "user_status")
            }
        }
        .padding()
    }
}
