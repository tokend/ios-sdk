// Auto-generated code. Do not edit.

import Foundation

// MARK: - ManageLimitsCreationOp

extension Horizon {
public struct ManageLimitsCreationOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountAddress
        case accountRole
        case annualOut
        case assetCode
        case dailyOut
        case isConvertNeeded
        case monthlyOut
        case statsOpType
        case weeklyOut
    }
    
    // MARK: Attributes
    
    public let accountAddress: String
    public let accountRole: UInt64?
    public let annualOut: Decimal
    public let assetCode: String
    public let dailyOut: Decimal
    public let isConvertNeeded: Bool
    public let monthlyOut: Decimal
    public let statsOpType: Enum
    public let weeklyOut: Decimal

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accountAddress = try container.decode(String.self, forKey: .accountAddress)
        self.accountRole = try? container.decode(UInt64.self, forKey: .accountRole)
        self.annualOut = try container.decodeDecimalString(key: .annualOut)
        self.assetCode = try container.decode(String.self, forKey: .assetCode)
        self.dailyOut = try container.decodeDecimalString(key: .dailyOut)
        self.isConvertNeeded = try container.decode(Bool.self, forKey: .isConvertNeeded)
        self.monthlyOut = try container.decodeDecimalString(key: .monthlyOut)
        self.statsOpType = try container.decode(Enum.self, forKey: .statsOpType)
        self.weeklyOut = try container.decodeDecimalString(key: .weeklyOut)
    }

}
}
