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
        
        // Dynamic cut and thin section properties from backend
        let cut: Bool?
        let thinSection: Bool?
        
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
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // Define keys for backend SampleResponseModel
            struct BackendKeys: CodingKey {
                var stringValue: String
                init?(stringValue: String) { self.stringValue = stringValue }
                var intValue: Int? { return nil }
                init?(intValue: Int) { return nil }
                
                static let rockName = BackendKeys(stringValue: "rock_name")!
                static let rockDescription = BackendKeys(stringValue: "rock_description")!
                static let picture = BackendKeys(stringValue: "picture")!
                static let cut = BackendKeys(stringValue: "cut")!
                static let thinSection = BackendKeys(stringValue: "thin_section")!
                static let locationName = BackendKeys(stringValue: "location_name")!
                static let locationCountry = BackendKeys(stringValue: "location_country")!
            }
            
            let backendContainer = try? decoder.container(keyedBy: BackendKeys.self)
            
            // Title
            if let titleVal = try? container.decodeIfPresent(String.self, forKey: .title) {
                self.title = titleVal
            } else if let rockName = try? backendContainer?.decodeIfPresent(String.self, forKey: .rockName) {
                self.title = rockName
            } else {
                self.title = nil
            }
            
            // Image
            if let imageVal = try? container.decodeIfPresent(String.self, forKey: .image) {
                if imageVal.hasPrefix("http") || imageVal == "Sin muestra" {
                    self.image = imageVal == "Sin muestra" ? nil : imageVal
                } else {
                    self.image = "http://192.168.1.64:5173/\(imageVal)"
                }
            } else if let pic = try? backendContainer?.decodeIfPresent(String.self, forKey: .picture), pic != "Sin muestra", !pic.isEmpty {
                if pic.hasPrefix("http") {
                    self.image = pic
                } else {
                    self.image = "http://192.168.1.64:5173/\(pic)"
                }
            } else {
                self.image = nil
            }
            
            // Video
            self.video = try? container.decodeIfPresent(String.self, forKey: .video)
            
            // Long description
            if let longDescVal = try? container.decodeIfPresent(String.self, forKey: .longDesc) {
                self.longDesc = longDescVal
            } else if let desc = try? backendContainer?.decodeIfPresent(String.self, forKey: .rockDescription) {
                self.longDesc = desc
            } else {
                self.longDesc = nil
            }
            
            // aMemberOf / Type
            if let member = try? container.decodeIfPresent(String.self, forKey: .aMemberOf) {
                self.aMemberOf = member
            } else if backendContainer != nil {
                self.aMemberOf = "Specimen Sample"
            } else {
                self.aMemberOf = nil
            }
            
            // Localities
            if let local = try? container.decodeIfPresent([String].self, forKey: .localities) {
                self.localities = local
            } else if let locName = try? backendContainer?.decodeIfPresent(String.self, forKey: .locationName),
                      let locCountry = try? backendContainer?.decodeIfPresent(String.self, forKey: .locationCountry) {
                self.localities = ["\(locName), \(locCountry)"]
            } else {
                self.localities = nil
            }
            
            // alsoKnownAs
            if let also = try? container.decodeIfPresent([String].self, forKey: .alsoKnownAs) {
                self.alsoKnownAs = also
            } else if let cut = try? backendContainer?.decodeIfPresent(Bool.self, forKey: .cut),
                      let thin = try? backendContainer?.decodeIfPresent(Bool.self, forKey: .thinSection) {
                self.alsoKnownAs = [
                    "Corte físico: \(cut ? "Sí" : "No")",
                    "Lámina delgada: \(thin ? "Sí" : "No")"
                ]
            } else {
                self.alsoKnownAs = nil
            }
            
            // Decode cut and thinSection fields directly
            self.cut = try? backendContainer?.decodeIfPresent(Bool.self, forKey: .cut)
            self.thinSection = try? backendContainer?.decodeIfPresent(Bool.self, forKey: .thinSection)
            
            // Other optional attributes
            self.formula = try? container.decodeIfPresent(String.self, forKey: .formula)
            self.hardness = try? container.decodeIfPresent(Int.self, forKey: .hardness)
            self.color = try? container.decodeIfPresent(String.self, forKey: .color)
            self.magnetic = try? container.decodeIfPresent(Bool.self, forKey: .magnetic)
            self.latitude = try? container.decodeIfPresent(Double.self, forKey: .latitude)
            self.longitude = try? container.decodeIfPresent(Double.self, forKey: .longitude)
            self.healthRisks = try? container.decodeIfPresent(String.self, forKey: .healthRisks)
            self.images = try? container.decodeIfPresent([String].self, forKey: .images)
            self.frequentlyAskedQuestions = try? container.decodeIfPresent([String].self, forKey: .frequentlyAskedQuestions)
            self.physicalProperties = try? container.decodeIfPresent(PhysicalProperties.self, forKey: .physicalProperties)
            self.chemicalProperties = try? container.decodeIfPresent(ChemicalProperties.self, forKey: .chemicalProperties)
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
