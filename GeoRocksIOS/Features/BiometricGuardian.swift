// -----------------------------------------------------------
// BiometricGuardian.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file demonstrates the use of LocalAuthentication to prompt
// the user for biometric authentication (Face ID/Touch ID).
// -----------------------------------------------------------

import LocalAuthentication
import SwiftUI

/// BiometricAuthManager manages the Face ID / Touch ID authentication flow.
class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    
    private init() {}
    
    /// This function attempts to evaluate a policy for biometric authentication.
    /// A success or failure result is returned via a completion callback.
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // The device is checked to see if biometrics are available.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Unlock GeoRocks"
            ) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, evaluateError?.localizedDescription)
                    }
                }
            }
        } else {
            completion(false, "Biometric authentication not available.")
        }
    }
}

/// A SwiftUI view that includes a button to demonstrate biometric authentication.
struct BiometricAuthExampleView: View {
    @State private var statusMessage: String = "Locked"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Biometric Guardian")
                .font(.title)
            
            Text(statusMessage)
                .font(.headline)
            
            Button("Authenticate with Biometrics") {
                BiometricAuthManager.shared.authenticateUser { success, errorMessage in
                    if success {
                        statusMessage = "Unlocked!"
                    } else {
                        statusMessage = "Authentication failed: \(errorMessage ?? "Unknown error")"
                    }
                }
            }
        }
        .padding()
    }
}
