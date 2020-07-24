// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountSpecificRuleResource

extension Horizon {
open class AccountSpecificRuleResource: Resource {
    
    open override class var resourceType: String {
        return "account-specific-rules"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case forbids
        case ledgerKey
    }
    
    // MARK: Attributes
    
    open var accountId: String? {
        return self.stringOptionalValue(key: CodingKeys.accountId)
    }
    
    open var forbids: Bool {
        return self.boolOptionalValue(key: CodingKeys.forbids) ?? false
    }
    
    open var ledgerKey: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.ledgerKey) ?? [:]
    }
    
}
}
