// Auto-generated code. Do not edit.

import Foundation

// MARK: - Fee

public struct Fee: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case calculatedPercent
        case fixed
    }
    
    // MARK: Attributes
    
    public let calculatedPercent: Decimal
    public let fixed: Decimal

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.calculatedPercent = try container.decodeDecimalString(key: .calculatedPercent)
        self.fixed = try container.decodeDecimalString(key: .fixed)
    }

}
