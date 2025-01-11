// RockDto.swift
import Foundation

/// A data structure representing a rock object.
/// The properties have been made optional if they are not always present.
struct RockDto: Identifiable, Codable {
    let id: String
    let thumbnail: String?
    let title: String
    
    // Additional fields
    let color: String?
    let hardness: Int?
    let formula: String?
    let shortDescription: String?
    let latitude: Double?
    let longitude: Double?
}

