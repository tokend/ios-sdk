// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - FeeRecordResource

extension Horizon {
open class FeeRecordResource: Resource {
    
    open override class var resourceType: String {
        return "fees"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case appliedTo
        case fixed
        case percent
        
        // relations
        case account
        case accountRole
        case asset
    }
    
    // MARK: Attributes
    
    open var appliedTo: Horizon.FeeAppliedTo? {
        return self.codableOptionalValue(key: CodingKeys.appliedTo)
    }
    
    open var fixed: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.fixed) ?? 0.0
    }
    
    open var percent: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.percent) ?? 0.0
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var accountRole: Horizon.AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountRole)
    }
    
    open var asset: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
}
