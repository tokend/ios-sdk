// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageSignerRoleOpResource

extension Horizon {
open class ManageSignerRoleOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "base-manage-signer-role-op"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case isReadOnly
        
        // relations
        case role
        case rules
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var isReadOnly: Bool {
        return self.boolOptionalValue(key: CodingKeys.isReadOnly) ?? false
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
