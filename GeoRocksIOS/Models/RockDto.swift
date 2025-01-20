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
