// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageAccountRoleDetailsResource

open class OpManageAccountRoleDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-account-role"
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
    
    open var role: AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
    open var rules: [AccountRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
