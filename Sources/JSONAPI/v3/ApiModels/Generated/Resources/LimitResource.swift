// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LimitResource

open class LimitResource: Resource {
    
    open override class var resourceType: String {
        return "limits"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case annualOut
        case dailyOut
        case isConvertNeeded
        case monthlyOut
        case statsOpType
        case weeklyOut
        
        // relations
        case account
        case accountRole
        case asset
    }
    
    // MARK: Attributes
    
    open var annualOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.annualOut) ?? 0.0
    }
    
    open var dailyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.dailyOut) ?? 0.0
    }
    
    open var isConvertNeeded: Bool {
        return self.boolOptionalValue(key: CodingKeys.isConvertNeeded) ?? false
    }
    
    open var monthlyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.monthlyOut) ?? 0.0
    }
    
    open var statsOpType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.statsOpType) ?? 0
    }
    
    open var weeklyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.weeklyOut) ?? 0.0
    }
    
    // MARK: Relations
    
    open var account: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var accountRole: AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountRole)
    }
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
