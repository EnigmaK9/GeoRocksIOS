// DiskCacheManager.swift
import Foundation

/// This class handles reading and writing JSON data to local storage.
class DiskCacheManagerV2 {
    static let shared = DiskCacheManagerV2()
    private init() {}
    
    private let fileName = "rocksData.json"
    
    /// Retrieves the file URL in the Documents directory.
    private func getFileURL() throws -> URL {
        guard let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NSError(domain: "DiskCacheManager",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "The Documents directory could not be found."])
        }
        return documentDir.appendingPathComponent(fileName)
    }
    
    /// Saves an array of RockDto objects to disk.
    func saveRocks(_ rocks: [RockDto]) throws {
        let url = try getFileURL()
        let data = try JSONEncoder().encode(rocks)
        try data.write(to: url, options: .atomic)
    }
    
    /// Loads an array of RockDto objects from disk if the file exists.
    func loadRocks() throws -> [RockDto] {
        let url = try getFileURL()
        let data = try Data(contentsOf: url)
        let loaded = try JSONDecoder().decode([RockDto].self, from: data)
        return loaded
    }
    
    /// (Optional) Removes the JSON file if it exists.
    func removeRocksData() throws {
        let url = try getFileURL()
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
}
