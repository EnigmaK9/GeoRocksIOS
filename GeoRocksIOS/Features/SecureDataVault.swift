// -----------------------------------------------------------
// SecureDataVault.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file provides a simple wrapper for secure storage
// using the iOS Keychain. It demonstrates how to safely
// store, retrieve, and delete sensitive data.
//
// -----------------------------------------------------------

import Foundation
import Security
import SwiftUI

/// SecureStorage is a basic Keychain interface that
/// supports saving, retrieving, and deleting data.
class SecureStorage {
    /// A shared singleton instance for global Keychain operations.
    static let shared = SecureStorage()
    
    private init() {}
    
    /// Saves a string value to the Keychain under the given key.
    /// - Parameters:
    ///   - key: Unique identifier for the item
    ///   - value: Data to be stored
    /// - Returns: Boolean indicating success or failure
    func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemDelete(query as CFDictionary) // Remove old item if it exists
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// Retrieves a string value from the Keychain using the given key.
    /// - Parameter key: Unique identifier for the item
    /// - Returns: The string value if found, otherwise `nil`
    func retrieve(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    /// Deletes a string value from the Keychain.
    /// - Parameter key: Unique identifier for the item
    /// - Returns: Boolean indicating success or failure
    func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

/// A sample SwiftUI view demonstrating how to use SecureStorage
/// to safely manage sensitive data in the Keychain.
struct SecureStorageExampleView: View {
    @State private var savedValue: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Secure Data Vault")
                .font(.title)
            
            Button("Save to Keychain") {
                SecureStorage.shared.save(key: "testKey", value: "TopSecretValue")
            }
            
            Button("Retrieve from Keychain") {
                if let retrieved = SecureStorage.shared.retrieve(key: "testKey") {
                    savedValue = retrieved
                }
            }
            
            Button("Delete from Keychain") {
                _ = SecureStorage.shared.delete(key: "testKey")
            }
            
            Text("Value: \(savedValue)")
        }
        .padding()
    }
}
