// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageAccountRuleOpResource

extension Horizon {
open class ManageAccountRuleOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "base-manage-account-rule-op"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case details
        case forbids
        case resource
        
        // relations
        case rule
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var forbids: Bool {
        return self.boolOptionalValue(key: CodingKeys.forbids) ?? false
    }
    
    open var resource: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.resource) ?? [:]
    }
    
    // MARK: Relations
    
    open var rule: Horizon.AccountRuleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.rule)
    }
    
}
}
