// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SignerRuleResource

open class SignerRuleResource: Resource {
    
    open override class var resourceType: String {
        return "signer-rules"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case details
        case forbids
        case isDefault
        case resource
        
        // relations
        case owner
        case rules
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
    
    open var isDefault: Bool {
        return self.boolOptionalValue(key: CodingKeys.isDefault) ?? false
    }
    
    open var resource: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.resource) ?? [:]
    }
    
    // MARK: Relations
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var rules: [SignerRuleResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.rules)
    }
    
}
