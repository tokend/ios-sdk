// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageSignerRoleDetailsResource

open class OpManageSignerRoleDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-signer-role"
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
    
    open var role: SignerRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
    open var rules: [SignerRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
