// Auto-generated code. Do not edit.

import Foundation

// MARK: - ParticularBalanceChangeEffect

extension Horizon {
public struct ParticularBalanceChangeEffect: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case assetCode
        case balanceAddress
        case fee
    }
    
    // MARK: Attributes
    
    public let amount: Decimal
    public let assetCode: String
    public let balanceAddress: String
    public let fee: Fee

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.amount = try container.decodeDecimalString(key: .amount)
        self.assetCode = try container.decode(String.self, forKey: .assetCode)
        self.balanceAddress = try container.decode(String.self, forKey: .balanceAddress)
        self.fee = try container.decode(Fee.self, forKey: .fee)
    }

}
}
