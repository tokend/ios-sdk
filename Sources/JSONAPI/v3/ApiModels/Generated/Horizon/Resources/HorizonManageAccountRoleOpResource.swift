// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageAccountRoleOpResource

extension Horizon {
open class ManageAccountRoleOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "base-manage-account-role-op"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        
        // relations
        case role
        case rules
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    // MARK: Relations
    
    open var role: Horizon.AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
    open var rules: [Horizon.AccountRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
}
