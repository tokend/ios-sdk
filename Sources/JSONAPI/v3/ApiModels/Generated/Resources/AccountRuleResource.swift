// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountRuleResource

open class AccountRuleResource: Resource {
    
    open override class var resourceType: String {
        return "account-rules"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case details
        case forbids
        case resource
    }
    
    // MARK: Attributes
    
    open var action: XdrEnumValue? {
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
    
}
