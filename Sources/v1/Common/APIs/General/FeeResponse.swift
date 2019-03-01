import Foundation
import TokenDWallet

public struct FeeResponse: Decodable {
    
    public typealias FeeType = TokenDWallet.FeeType
    
    public let asset: String
    public let feeType: Int32
    public let subtype: Int32
    public let accountId: String
    public let fixed: Decimal
    public let percent: Decimal
    public let upperBound: Decimal
    public let lowerBound: Decimal
    public let feeAsset: String
    
    public var feeTypeValue: FeeType? {
        return FeeType(rawValue: feeType)
    }
    
    public enum FeeResponseCodingKeys: String, CodingKey {
        case asset
        case feeType
        case subtype
        case accountId
        case fixed
        case percent
        case upperBound
        case lowerBound
        case feeAsset
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeeResponseCodingKeys.self)
        
        self.asset = try container.decodeString(key: .asset)
        self.feeType = try container.decode(Int32.self, forKey: .feeType)
        self.subtype = try container.decode(Int32.self, forKey: .subtype)
        self.accountId = try container.decodeString(key: .accountId)
        self.fixed = try container.decodeDecimalString(key: .fixed)
        self.percent = try container.decodeDecimalString(key: .percent)
        self.lowerBound = try container.decodeDecimalString(key: .lowerBound)
        self.upperBound = try container.decodeDecimalString(key: .upperBound)
        self.feeAsset = try container.decodeString(key: .feeAsset)
    }
}
