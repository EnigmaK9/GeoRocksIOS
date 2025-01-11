// -----------------------------------------------------------
// EnhancedLoggerPro.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file demonstrates a simple but powerful logging utility
// that helps capture user actions, errors, and debug messages.
// -----------------------------------------------------------

import Foundation
import SwiftUI

/// LoggingManager is a central class for logging throughout the app.
class LoggingManager {
    /// A shared singleton instance to access the logger anywhere in the app.
    static let shared = LoggingManager()
    
    private init() {}
    
    /// Logs a user action, which can include additional metadata for context.
    /// - Parameters:
    ///   - action: A description of the user's action
    ///   - metadata: Optional key-value pairs providing additional context
    func logUserAction(action: String, metadata: [String: Any] = [:]) {
        print("Logging Action: \(action), Metadata: \(metadata)")
    }
    
    /// Logs an error, capturing the error message and optional metadata.
    /// - Parameters:
    ///   - error: The `Error` object to log
    ///   - metadata: Optional key-value pairs providing context about the error
    func logError(error: Error, metadata: [String: Any] = [:]) {
        print("Logging Error: \(error.localizedDescription), Metadata: \(metadata)")
    }
    
    /// Logs a debug message, suitable for providing insight during development and testing.
    /// - Parameters:
    ///   - message: The debug message to log
    ///   - metadata: Optional key-value pairs providing extra context
    func logDebug(message: String, metadata: [String: Any] = [:]) {
        print("Logging Debug: \(message), Metadata: \(metadata)")
    }
}

/// A sample SwiftUI view demonstrating how to use the LoggingManager.
struct LoggingExampleView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Enhanced Logger Pro")
                .font(.title)
            
            Button("Log Action") {
                LoggingManager.shared.logUserAction(
                    action: "User tapped the action button",
                    metadata: ["button": "Action"]
                )
            }
            
            Button("Log Error") {
                let sampleError = NSError(
                    domain: "com.georocks.error",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Sample not found"]
                )
                LoggingManager.shared.logError(error: sampleError)
            }
            
            Button("Log Debug") {
                LoggingManager.shared.logDebug(
                    message: "Debugging the logger functionality",
                    metadata: ["level": "verbose"]
                )
            }
        }
        .padding()
    }
}
