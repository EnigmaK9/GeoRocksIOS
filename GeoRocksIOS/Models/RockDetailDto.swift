    //
    //  RockDetailDto.swift
    //  GeoRocksIOS
    //
    //  Created by Carlos Ignacio Padilla Herrera on 23/12/24.
    //

    import Foundation

    struct RockDetailDto: Decodable {
        
        // The title of the rock is stored
        let title: String?
        
        // The image URL of the rock is stored
        let image: String?
        
        // The video URL related to the rock is stored
        let video: String?
        
        // A long description of the rock is stored
        let longDesc: String?
        
        // The category or group the rock is a member of is stored
        let aMemberOf: String?
        
        // Alternate names for the rock are stored
        let alsoKnownAs: [String]?
        
        // The chemical formula of the rock is stored
        let formula: String?
        
        // The hardness of the rock is stored
        let hardness: Int?
        
        // The color description of the rock is stored
        let color: String?
        
        // Indicates whether the rock is magnetic
        let magnetic: Bool?
        
        // The latitude coordinate of the rock's locality is stored
        let latitude: Double?
        
        // The longitude coordinate of the rock's locality is stored
        let longitude: Double?
        
        // Health risks associated with the rock are stored
        let healthRisks: String?
        
        // Additional images of the rock are stored
        let images: [String]?
        
        // Locations where the rock is found are stored
        let localities: [String]?
        
        // Frequently asked questions about the rock are stored
        let frequentlyAskedQuestions: [String]?
        
        // Physical properties of the rock are stored
        let physicalProperties: PhysicalProperties?
        
        // Chemical properties of the rock are stored
        let chemicalProperties: ChemicalProperties?
        
        // MARK: - CodingKeys
        enum CodingKeys: String, CodingKey {
            case title
            case image
            case video
            case longDesc = "long_desc"
            case aMemberOf = "a_member_of"
            case alsoKnownAs = "also_known_as"
            case formula
            case hardness
            case color
            case magnetic
            case latitude
            case longitude
            case healthRisks = "health_risks"
            case images
            case localities
            case frequentlyAskedQuestions = "frequently_asked_questions"
            case physicalProperties = "physical_properties"
            case chemicalProperties = "chemical_properties"
        }
        
        // MARK: - PhysicalProperties
        struct PhysicalProperties: Decodable {
            // The crystal system of the rock is stored
            let ppCrystalSystem: String?
            
            // The colors associated with the rock are stored
            let ppColors: [String]?
            
            // The luster of the rock is stored
            let ppLuster: String?
            
            // The diaphaneity (transparency) of the rock is stored
            let ppDiaphaneity: String?
            
            // The streak color of the rock is stored
            let ppStreak: String?
            
            // The tenacity of the rock is stored
            let ppTenacity: String?
            
            // The cleavage of the rock is stored
            let ppCleavage: String?
            
            // The fracture pattern of the rock is stored
            let ppFracture: String?
            
            // The density of the rock is stored
            let ppDensity: String?
            
            // The hardness value of the rock is stored
            let ppHardness: Int?
            
            // Indicates whether the rock is magnetic
            let ppMagnetic: Bool?
            
            enum CodingKeys: String, CodingKey {
                case ppCrystalSystem = "pp_crystal_system"
                case ppColors = "pp_colors"
                case ppLuster = "pp_luster"
                case ppDiaphaneity = "pp_diaphaneity"
                case ppStreak = "pp_streak"
                case ppTenacity = "pp_tenacity"
                case ppCleavage = "pp_cleavage"
                case ppFracture = "pp_fracture"
                case ppDensity = "pp_density"
                case ppHardness = "pp_hardness"
                case ppMagnetic = "pp_magnetic"
            }
        }
        
        // MARK: - ChemicalProperties
        struct ChemicalProperties: Decodable {
            // The chemical classification of the rock is stored
            let chemicalClassification: String?
            
            // The chemical formula of the rock is stored
            let cpFormula: String?
            
            // Elements listed in the rock's composition are stored
            let cpElementsListed: [String]?
            
            // Common impurities found in the rock are stored
            let cpCommonImpurities: [String]?
            
            enum CodingKeys: String, CodingKey {
                case chemicalClassification = "cp_chemical_classification"
                case cpFormula = "cp_formula"
                case cpElementsListed = "cp_elements_listed"
                case cpCommonImpurities = "cp_common_impurities"
            }
        }
    }
