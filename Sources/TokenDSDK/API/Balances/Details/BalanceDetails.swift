import Foundation

public struct BalanceDetails {
    public let accountId: String
    public let asset: String
    public let balance: Decimal
    public let balanceId: String
    public let convertedBalance: Decimal
    public let convertedLocked: Decimal
    public let locked: Decimal
    public let requireReview: Bool
}

extension BalanceDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case accountId
        case asset
        case balance
        case balanceId
        case convertedBalance
        case convertedLocked
        case locked
        case requireReview
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.balance = try container.decodeDecimalString(key: .balance)
        self.convertedBalance = try container.decodeDecimalString(key: .convertedBalance)
        self.locked = try container.decodeDecimalString(key: .locked)
        self.convertedLocked = try container.decodeDecimalString(key: .convertedLocked)
        self.asset = try container.decode(String.self, forKey: .asset)
        self.balanceId = try container.decode(String.self, forKey: .balanceId)
        self.requireReview = try container.decode(Bool.self, forKey: .requireReview)
        self.accountId = try container.decode(String.self, forKey: .accountId)
    }
}
