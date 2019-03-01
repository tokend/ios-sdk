// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateAccountDetailsResource

open class OpCreateAccountDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-account"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case account
        case role
    }
    
    // MARK: Relations
    
    open var account: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var role: AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
}
