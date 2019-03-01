// Auto-generated code. Do not edit.

import Foundation

// MARK: - LimitsRemoval

public struct LimitsRemoval: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case limtisId
    }
    
    // MARK: Attributes
    
    public let limtisId: Int64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.limtisId = try container.decode(Int64.self, forKey: .limtisId)
    }

}
