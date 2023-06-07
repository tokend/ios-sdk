// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LinkTokenResource

extension PlaidIntegration {
open class LinkTokenResource: Resource {
    
    open override class var resourceType: String {
        return "link_token"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case expirationTimestamp
        case initializedBefore
        case linkToken
    }
    
    // MARK: Attributes
    
    open var expirationTimestamp: Date {
        return self.dateOptionalValue(key: CodingKeys.expirationTimestamp) ?? Date()
    }
    
    open var initializedBefore: Bool {
        return self.boolOptionalValue(key: CodingKeys.initializedBefore) ?? false
    }
    
    open var linkToken: String {
        return self.stringOptionalValue(key: CodingKeys.linkToken) ?? ""
    }
    
}
}
