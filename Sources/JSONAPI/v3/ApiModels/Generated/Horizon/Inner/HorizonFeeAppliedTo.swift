// Auto-generated code. Do not edit.

import Foundation

// MARK: - FeeAppliedTo

extension Horizon {
public struct FeeAppliedTo: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case asset
        case feeType
        case feeTypeExtended
        case lowerBound
        case subtype
        case upperBound
    }
    
    // MARK: Attributes
    
    public let asset: String
    public let feeType: Int32
    public let feeTypeExtended: Enum
    public let lowerBound: Decimal
    public let subtype: Int64
    public let upperBound: Decimal

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.asset = try container.decode(String.self, forKey: .asset)
        self.feeType = try container.decode(Int32.self, forKey: .feeType)
        self.feeTypeExtended = try container.decode(Enum.self, forKey: .feeTypeExtended)
        self.lowerBound = try container.decodeDecimalString(key: .lowerBound)
        self.subtype = try container.decode(Int64.self, forKey: .subtype)
        self.upperBound = try container.decodeDecimalString(key: .upperBound)
    }

}
}
