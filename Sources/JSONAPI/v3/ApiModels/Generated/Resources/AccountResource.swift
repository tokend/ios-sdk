// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountResource

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
        case referrer
        case role
    }
    
    // MARK: Attributes
    
    open var kycRecoveryStatus: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.kycRecoveryStatus)
    }
    
    // MARK: Relations
    
    open var balances: [BalanceResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.balances)
    }
    
    open var externalSystemIds: [ExternalSystemIdResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.externalSystemIds)
    }
    
    open var fees: [FeeResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.fees)
    }

    open var kycData: AccountKYCResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.kycData)
    }
    
    open var limits: [LimitResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.limits)
    }
    
    open var referrer: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.referrer)
    }
    
    open var role: AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
}

open class AccountKYCResource: Resource {

    open override class var resourceType: String {
        return "account-kyc"
    }

    public enum CodingKeys: String, CodingKey {
        // attributes
        case kycData
    }

    // MARK: Attributes

    open var kycData: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.kycData) ?? [:]
    }

}
