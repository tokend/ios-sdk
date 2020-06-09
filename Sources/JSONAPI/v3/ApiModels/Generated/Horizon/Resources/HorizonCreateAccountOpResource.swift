// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateAccountOpResource

extension Horizon {
open class CreateAccountOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-account"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case account
        case role
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var role: Horizon.AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
}
}
