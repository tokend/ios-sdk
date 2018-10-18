import Foundation

public struct OrderBookResponse: Decodable {
    
    public let pagingToken: String
    public let baseAssetCode: String
    public let quoteAssetCode: String
    public let isBuy: Bool
    public let baseAmount: Decimal
    public let quoteAmount: Decimal
    public let price: Decimal
    
    enum CodingKeys: String, CodingKey {
        case pagingToken
        case baseAssetCode
        case quoteAssetCode
        case isBuy
        case baseAmount
        case quoteAmount
        case price
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.baseAmount = try container.decodeDecimalString(key: .baseAmount)
        self.quoteAmount = try container.decodeDecimalString(key: .quoteAmount)
        self.price = try container.decodeDecimalString(key: .price)
        self.pagingToken = try container.decode(String.self, forKey: .pagingToken)
        self.baseAssetCode = try container.decode(String.self, forKey: .baseAssetCode)
        self.quoteAssetCode = try container.decode(String.self, forKey: .quoteAssetCode)
        self.isBuy = try container.decode(Bool.self, forKey: .isBuy)
    }
}
