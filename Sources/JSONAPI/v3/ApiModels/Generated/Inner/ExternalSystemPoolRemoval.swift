// Auto-generated code. Do not edit.

import Foundation

// MARK: - ExternalSystemPoolRemoval

public struct ExternalSystemPoolRemoval: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case poolId
    }
    
    // MARK: Attributes
    
    public let poolId: UInt64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.poolId = try container.decode(UInt64.self, forKey: .poolId)
    }

}
