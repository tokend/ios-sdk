// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountRoleResource

extension Horizon {
open class AccountRoleResource: Resource {
    
    open override class var resourceType: String {
        return "account-roles"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        
        // relations
        case rules
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    // MARK: Relations
    
    open var rules: [Horizon.AccountRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
}
