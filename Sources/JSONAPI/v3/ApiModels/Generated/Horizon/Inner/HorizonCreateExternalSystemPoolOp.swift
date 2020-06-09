// Auto-generated code. Do not edit.

import Foundation

// MARK: - CreateExternalSystemPoolOp

extension Horizon {
public struct CreateExternalSystemPoolOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case data
        case externalSystemType
        case parent
        case poolId
    }
    
    // MARK: Attributes
    
    public let data: String
    public let externalSystemType: Int32
    public let parent: UInt64
    public let poolId: UInt64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.data = try container.decode(String.self, forKey: .data)
        self.externalSystemType = try container.decode(Int32.self, forKey: .externalSystemType)
        self.parent = try container.decode(UInt64.self, forKey: .parent)
        self.poolId = try container.decode(UInt64.self, forKey: .poolId)
    }

}
}
