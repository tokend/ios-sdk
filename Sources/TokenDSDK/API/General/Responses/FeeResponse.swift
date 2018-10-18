import Foundation
import TokenDWallet

public struct FeeResponse: Decodable {
    
    public typealias FeeType = TokenDWallet.FeeType
    
    public let asset: String
    public let feeType: Int32
    public let fixed: Decimal
    public let percent: Decimal
    
    public var feeTypeValue: FeeType? {
        return FeeType(rawValue: feeType)
    }
    
    public enum FeeResponseCodingKeys: String, CodingKey {
        case asset
        case feeType
        case fixed
        case percent
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FeeResponseCodingKeys.self)
        
        self.asset = try container.decodeString(key: .asset)
        self.feeType = try container.decode(Int32.self, forKey: .feeType)
        self.fixed = try container.decodeDecimalString(key: .fixed)
        self.percent = try container.decodeDecimalString(key: .percent)
    }
}
