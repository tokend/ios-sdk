// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountResource

extension Horizon {
open class AccountResource: Resource {
    
    open override class var resourceType: String {
        return "accounts"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case kycRecoveryStatus
        
        // relations
        case balances
        case externalSystemIds
        case fees
        case kycData
        case limits
        case limitsWithStats
        case referrer
        case role
    }
    
    // MARK: Attributes
    
    open var kycRecoveryStatus: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.kycRecoveryStatus)
    }
    
    // MARK: Relations
    
    open var balances: [Horizon.BalanceResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.balances)
    }
    
    open var externalSystemIds: [Horizon.ExternalSystemIDResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.externalSystemIds)
    }
    
    open var fees: [Horizon.FeeRecordResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.fees)
    }
    
    open var kycData: Horizon.AccountKYCResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.kycData)
    }
    
    open var limits: [Horizon.LimitsResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.limits)
    }
    
    open var limitsWithStats: [Horizon.LimitsWithStatsResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.limitsWithStats)
    }
    
    open var referrer: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.referrer)
    }
    
    open var role: Horizon.AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
}
}
