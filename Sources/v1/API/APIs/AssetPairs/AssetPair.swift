import Foundation

public struct AssetPair {
    
    public let base: String
    public let quote: String
    public let currentPrice: Decimal
    public let physicalPrice: Decimal
    
    private let policies: [PolicyStruct]?
    
    public func meetsPolicy(_ policy: Policy) -> Bool {
        let containsPolicy = self.policies?.contains(where: { (policiesElement) -> Bool in
            return policy.rawValue == policiesElement.value
        })
        return containsPolicy ?? false
    }
}

extension AssetPair {
    
    public enum Policy: Int {
        case tradeableSecondaryMarket   = 1
        case physicalPriceRestriction   = 2
        case currentPriceRestriction    = 4
    }
}

extension AssetPair {
    private struct PolicyStruct: Decodable {
        
        let name: String
        let value: Int
    }
}

extension AssetPair: Decodable {
    enum CodingKeys: String, CodingKey {
        case base
        case quote
        case currentPrice
        case physicalPrice
        case policies
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.currentPrice = try container.decodeDecimalString(key: .currentPrice)
        self.physicalPrice = try container.decodeDecimalString(key: .physicalPrice)
        self.base = try container.decode(String.self, forKey: .base)
        self.quote = try container.decode(String.self, forKey: .quote)
        self.policies = try container.decodeIfPresent([PolicyStruct].self, forKey: .policies)
    }
}
