// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SignerRoleResource

extension Horizon {
open class SignerRoleResource: Resource {
    
    open override class var resourceType: String {
        return "signer-roles"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        
        // relations
        case owner
        case rules
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    // MARK: Relations
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var rules: [Horizon.SignerRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
}
