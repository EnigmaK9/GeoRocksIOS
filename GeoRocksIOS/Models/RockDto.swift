// RockDto.swift
import Foundation

/// A data structure representing a rock object.
/// The properties have been made optional if they are not always present.
struct RockDto: Identifiable, Codable {
    let id: String
    let thumbnail: String?
    let title: String
    
    // Additional fields
    let color: String?              // Color of the rock
    let hardness: Int?              // Hardness value of the rock
    let formula: String?            // Chemical formula of the rock
    let shortDescription: String?    // Short description of the rock
    let latitude: Double?           // Latitude coordinate for the rock's location
    let longitude: Double?          // Longitude coordinate for the rock's location
    let aMemberOf: String?          // Classification of the rock (e.g., Igneous, Metamorphic)
    let healthRisks: String?        // Associated health risks of the rock

}
