// -----------------------------------------------------------
// OfflineCacheEngine.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This file illustrates a simple caching mechanism using
// local storage on the device. It demonstrates saving,
// loading, and removing data from the app's cache directory.
//
// -----------------------------------------------------------

import Foundation
import SwiftUI

/// DiskCacheManager enables saving, loading, and removing
/// data in the app's cache directory.
class DiskCacheManager {
    static let shared = DiskCacheManager()
    
    private init() {}
    
    /// Saves the provided data to a file within the cache directory.
    /// - Parameters:
    ///   - data: The raw Data to be stored
    ///   - fileName: The name of the file to store the data in
    func saveData(_ data: Data, fileName: String) throws {
        let url = try cacheURL(for: fileName)
        try data.write(to: url)
    }
    
    /// Loads data from a file within the cache directory.
    /// - Parameter fileName: The name of the file to read
    /// - Returns: The Data if it exists, otherwise `nil`
    func loadData(fileName: String) throws -> Data? {
        let url = try cacheURL(for: fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            return try Data(contentsOf: url)
        }
        return nil
    }
    
    /// Removes a file from the cache directory if it exists.
    /// - Parameter fileName: The name of the file to remove
    func removeData(fileName: String) throws {
        let url = try cacheURL(for: fileName)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    /// Constructs a URL for a file in the cache directory.
    /// - Parameter fileName: The name of the file
    /// - Returns: A valid file URL in the cache directory
    private func cacheURL(for fileName: String) throws -> URL {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "DiskCacheError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cache directory not found"])
        }
        return cacheDirectory.appendingPathComponent(fileName)
    }
}

/// A sample SwiftUI view demonstrating how to use the DiskCacheManager
/// for saving, loading, and removing data from local storage.
struct OfflineCachingExampleView: View {
    @State private var message: String = "No data cached yet"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Offline Cache Engine")
                .font(.title)
            
            Button("Save Data") {
                let sample = "Hello, Offline Cache!"
                guard let data = sample.data(using: .utf8) else { return }
                
                do {
                    try DiskCacheManager.shared.saveData(data, fileName: "sample.cache")
                    message = "Data Saved Locally!"
                } catch {
                    message = "Error saving data: \(error.localizedDescription)"
                }
            }
            
            Button("Load Data") {
                do {
                    if let loadedData = try DiskCacheManager.shared.loadData(fileName: "sample.cache"),
                       let text = String(data: loadedData, encoding: .utf8) {
                        message = "Loaded: \(text)"
                    } else {
                        message = "No cached data found."
                    }
                } catch {
                    message = "Error loading data: \(error.localizedDescription)"
                }
            }
            
            Button("Remove Data") {
                do {
                    try DiskCacheManager.shared.removeData(fileName: "sample.cache")
                    message = "Data removed from cache."
                } catch {
                    message = "Error removing data: \(error.localizedDescription)"
                }
            }
            
            Text(message)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
