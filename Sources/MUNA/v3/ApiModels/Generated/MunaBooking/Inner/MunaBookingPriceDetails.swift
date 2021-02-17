// Auto-generated code. Do not edit.

import Foundation

// MARK: - PriceDetails

extension MunaBooking {
public struct PriceDetails: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case asset
    }
    
    // MARK: Attributes
    
    public let amount: Decimal
    public let asset: String

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.amount = try container.decodeDecimalString(key: .amount)
        self.asset = try container.decode(String.self, forKey: .asset)
    }

}
}
