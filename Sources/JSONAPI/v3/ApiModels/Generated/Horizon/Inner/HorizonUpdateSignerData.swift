// Auto-generated code. Do not edit.

import Foundation

// MARK: - UpdateSignerData

extension Horizon {
public struct UpdateSignerData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case identity
        case roleId
        case weight
    }
    
    // MARK: Attributes
    
    public let details: [String: Any]
    public let identity: UInt32
    public let roleId: UInt64
    public let weight: UInt32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.details = try container.decodeDictionary([String: Any].self, forKey: .details)
        self.identity = try container.decode(UInt32.self, forKey: .identity)
        self.roleId = try container.decode(UInt64.self, forKey: .roleId)
        self.weight = try container.decode(UInt32.self, forKey: .weight)
    }

}
}
