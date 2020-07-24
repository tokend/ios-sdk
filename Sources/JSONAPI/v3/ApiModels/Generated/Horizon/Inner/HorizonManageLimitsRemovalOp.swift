// Auto-generated code. Do not edit.

import Foundation

// MARK: - ManageLimitsRemovalOp

extension Horizon {
public struct ManageLimitsRemovalOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case limitsId
    }
    
    // MARK: Attributes
    
    public let limitsId: Int64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.limitsId = try container.decode(Int64.self, forKey: .limitsId)
    }

}
}
