//
//  RockDetailDto.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 23/12/24.
//

import Foundation

struct RockDetailDto: Decodable {
    
    let title: String?
    let image: String?
    let video: String?
    let longDesc: String?
    let aMemberOf: String?
    let color: String?
    let images: [String]?
    let localities: [String]?
    let physicalProperties: PhysicalProperties?
    let chemicalProperties: ChemicalProperties?
    let latitude: Double?
    let longitude: Double?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case title
        case image
        case video
        case longDesc = "long_desc"
        case aMemberOf = "a_member_of"
        case color
        case images
        case localities
        case physicalProperties = "physical_properties"
        case chemicalProperties = "chemical_properties"
        case latitude
        case longitude
    }
    
    // MARK: - PhysicalProperties
    struct PhysicalProperties: Decodable {
        let crystalSystem: String?
        let colors: [String]?
        let hardness: Double?
        let magnetic: Bool?
        
        enum CodingKeys: String, CodingKey {
            case crystalSystem = "crystal_system"
            case colors = "pp_colors"
            case hardness = "pp_hardness"
            case magnetic = "pp_magnetic"
        }
    }
    
    // MARK: - ChemicalProperties
    struct ChemicalProperties: Decodable {
        let classification: String?
        let formula: String?
        
        enum CodingKeys: String, CodingKey {
            case classification = "chemical_classification"
            case formula = "cp_formula"
        }
    }
}
