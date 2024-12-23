// RockDto.swift
import Foundation

struct RockDto: Identifiable, Decodable {
    let id: String
    let thumbnail: String?
    let title: String
}
