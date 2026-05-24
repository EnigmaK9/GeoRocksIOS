import Foundation

struct RockDto: Identifiable, Codable {
    let id: String
    let thumbnail: String?
    let title: String
    
    // Additional fields
    var color: String?              // Changed to var
    var hardness: Int?              // Changed to var
    var formula: String?            // Changed to var
    var shortDescription: String?   // Changed to var
    var latitude: Double?           // Changed to var
    var longitude: Double?          // Changed to var
    var aMemberOf: String?          // Changed to var
    var healthRisks: String?        // Changed to var
    var magnetic: Bool?             // Added property
    
    // Specimen fields mapped from backend's SampleResponseModel
    var cut: Bool?
    var thinSection: Bool?
    var locationName: String?
    var locationCountry: String?

    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case title = "rock_name"
        case shortDescription = "rock_description"
        case thumbnail = "picture"
        case cut
        case thinSection = "thin_section"
        case locationName = "location_name"
        case locationCountry = "location_country"
        
        // Original keys if decoding from disk (for local cache compatibility)
        case origId = "id"
        case origTitle = "title"
        case origThumbnail = "thumbnail"
        case color
        case hardness
        case formula
        case latitude
        case longitude
        case aMemberOf = "aMemberOf"
        case healthRisks = "healthRisks"
        case magnetic
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try decoding with backend keys, fallback to disk cache keys
        if let uid = try? container.decode(UUID.self, forKey: .id) {
            self.id = uid.uuidString
        } else if let uidString = try? container.decode(String.self, forKey: .id) {
            self.id = uidString
        } else {
            self.id = try container.decode(String.self, forKey: .origId)
        }
        
        self.title = try (try? container.decode(String.self, forKey: .title)) ?? container.decode(String.self, forKey: .origTitle)
        
        self.shortDescription = (try? container.decodeIfPresent(String.self, forKey: .shortDescription)) ?? (try? container.decodeIfPresent(String.self, forKey: .shortDescription))
        
        let pic = (try? container.decodeIfPresent(String.self, forKey: .thumbnail)) ?? (try? container.decodeIfPresent(String.self, forKey: .origThumbnail))
        if let pic = pic, pic != "Sin muestra", !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.thumbnail = pic
            } else {
                // Point to public asset Vite server of frontend workspace
                self.thumbnail = "http://192.168.1.64:5173/\(pic)"
            }
        } else {
            self.thumbnail = nil
        }
        
        self.cut = try? container.decodeIfPresent(Bool.self, forKey: .cut)
        self.thinSection = try? container.decodeIfPresent(Bool.self, forKey: .thinSection)
        self.locationName = try? container.decodeIfPresent(String.self, forKey: .locationName)
        self.locationCountry = try? container.decodeIfPresent(String.self, forKey: .locationCountry)
        
        self.color = try? container.decodeIfPresent(String.self, forKey: .color)
        self.hardness = try? container.decodeIfPresent(Int.self, forKey: .hardness)
        self.formula = try? container.decodeIfPresent(String.self, forKey: .formula)
        self.latitude = try? container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try? container.decodeIfPresent(Double.self, forKey: .longitude)
        self.aMemberOf = try? container.decodeIfPresent(String.self, forKey: .aMemberOf)
        self.healthRisks = try? container.decodeIfPresent(String.self, forKey: .healthRisks)
        self.magnetic = try? container.decodeIfPresent(Bool.self, forKey: .magnetic)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .origId)
        try container.encode(title, forKey: .origTitle)
        try container.encode(thumbnail, forKey: .origThumbnail)
        try container.encodeIfPresent(shortDescription, forKey: .shortDescription)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(hardness, forKey: .hardness)
        try container.encodeIfPresent(formula, forKey: .formula)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(aMemberOf, forKey: .aMemberOf)
        try container.encodeIfPresent(healthRisks, forKey: .healthRisks)
        try container.encodeIfPresent(magnetic, forKey: .magnetic)
        try container.encodeIfPresent(cut, forKey: .cut)
        try container.encodeIfPresent(thinSection, forKey: .thinSection)
        try container.encodeIfPresent(locationName, forKey: .locationName)
        try container.encodeIfPresent(locationCountry, forKey: .locationCountry)
    }
    
    // Method to merge details
    mutating func mergeDetails(_ detail: RockDetailDto) {
        self.color = detail.color
        self.hardness = detail.hardness
        self.formula = detail.formula
        self.shortDescription = detail.longDesc
        self.latitude = detail.latitude
        self.longitude = detail.longitude
        self.aMemberOf = detail.aMemberOf
        self.healthRisks = detail.healthRisks
        self.magnetic = detail.magnetic
    }
}
