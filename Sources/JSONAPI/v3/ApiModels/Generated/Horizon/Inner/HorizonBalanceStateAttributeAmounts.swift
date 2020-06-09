// Auto-generated code. Do not edit.

import Foundation

// MARK: - BalanceStateAttributeAmounts

extension Horizon {
public struct BalanceStateAttributeAmounts: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case available
        case locked
    }
    
    // MARK: Attributes
    
    public let available: Decimal
    public let locked: Decimal

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.available = try container.decodeDecimalString(key: .available)
        self.locked = try container.decodeDecimalString(key: .locked)
    }

}
}
