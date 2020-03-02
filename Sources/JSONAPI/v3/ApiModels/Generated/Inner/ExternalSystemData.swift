// Auto-generated code. Do not edit.

import Foundation

// MARK: - ExternalSystemData

public struct ExternalSystemData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case data
        case type
    }
    
    // MARK: Attributes
    
    public let data: ExternalSystemDataEntry
    public let type: String

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try container.decode(ExternalSystemDataEntry.self, forKey: .data)
        self.type = try container.decode(String.self, forKey: .type)
    }

}
