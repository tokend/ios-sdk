import Foundation

public struct TradeResponse: Decodable {
    
    public let baseAmount: Decimal
    public let baseAsset: String
    public let createdAt: Date
    public let id: Int
    public let pagingToken: String
    public let price: Decimal
    public let quoteAmount: Decimal
    public let quoteAsset: String
    
    public enum CodingKeys: String, CodingKey {
        case baseAmount
        case baseAsset
        case createdAt
        case id
        case pagingToken
        case price
        case quoteAmount
        case quoteAsset
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.baseAmount = try container.decodeDecimalString(key: .baseAmount)
        self.baseAsset = try container.decode(String.self, forKey: .baseAsset)
        self.createdAt = try container.decodeDateString(key: .createdAt)
        self.id = try container.decode(Int.self, forKey: .id)
        self.pagingToken = try container.decode(String.self, forKey: .pagingToken)
        self.price = try container.decodeDecimalString(key: .price)
        self.quoteAmount = try container.decodeDecimalString(key: .quoteAmount)
        self.quoteAsset = try container.decode(String.self, forKey: .quoteAsset)
    }
}
