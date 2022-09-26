// Auto-generated code. Do not edit.

import Foundation

// MARK: - AssetDetails

extension Nifty {
public struct AssetDetails: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case additionalImages
        case fullDescription
        case location
        case logo
        case name
        case ownershipDocs
        case propertyValue
    }
    
    // MARK: Attributes
    
    public let additionalImages: [File]
    public let fullDescription: String
    public let location: String
    public let logo: File
    public let name: String
    public let ownershipDocs: [File]
    public let propertyValue: String

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.additionalImages = try container.decode([File].self, forKey: .additionalImages)
        self.fullDescription = try container.decode(String.self, forKey: .fullDescription)
        self.location = try container.decode(String.self, forKey: .location)
        self.logo = try container.decode(File.self, forKey: .logo)
        self.name = try container.decode(String.self, forKey: .name)
        self.ownershipDocs = try container.decode([File].self, forKey: .ownershipDocs)
        self.propertyValue = try container.decode(String.self, forKey: .propertyValue)
    }

}
}
