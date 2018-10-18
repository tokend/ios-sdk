import Foundation

public struct OfferResponse: Decodable {
    
    public let pagingToken: String
    public let ownerId: String
    public let offerId: UInt64
    public let orderBookId: Int
    public let baseBalanceId: String
    public let quoteBalanceId: String
    public let fee: Decimal
    public let baseAssetCode: String
    public let quoteAssetCode: String
    public let isBuy: Bool
    public let baseAmount: Decimal
    public let quoteAmount: Decimal
    public let price: Decimal
    public let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case pagingToken
        case ownerId
        case offerId
        case orderBookId
        case baseBalanceId
        case quoteBalanceId
        case fee
        case baseAssetCode
        case quoteAssetCode
        case isBuy
        case baseAmount
        case quoteAmount
        case price
        case createdAt
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.fee = try container.decodeDecimalString(key: .fee)
        self.baseAmount = try container.decodeDecimalString(key: .baseAmount)
        self.quoteAmount = try container.decodeDecimalString(key: .quoteAmount)
        self.price = try container.decodeDecimalString(key: .price)
        self.createdAt = try container.decodeDateString(key: .createdAt)
        self.pagingToken = try container.decode(String.self, forKey: .pagingToken)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
        self.offerId = try container.decode(UInt64.self, forKey: .offerId)
        self.orderBookId = try container.decode(Int.self, forKey: .orderBookId)
        self.baseBalanceId = try container.decode(String.self, forKey: .baseBalanceId)
        self.quoteBalanceId = try container.decode(String.self, forKey: .quoteBalanceId)
        self.baseAssetCode = try container.decode(String.self, forKey: .baseAssetCode)
        self.quoteAssetCode = try container.decode(String.self, forKey: .quoteAssetCode)
        self.isBuy = try container.decode(Bool.self, forKey: .isBuy)
    }
}
