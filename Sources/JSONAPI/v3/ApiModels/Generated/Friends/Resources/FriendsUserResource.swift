// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - UserResource

extension Friends {
open class UserResource: Resource {
    
    open override class var resourceType: String {
        return "users"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case identifierValue
        
        // relations
        case account
        case identity
    }
    
    // MARK: Attributes
    
    open var identifierValue: String {
        return self.stringOptionalValue(key: CodingKeys.identifierValue) ?? ""
    }
    
    // MARK: Relations
    
    open var account: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var identity: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.identity)
    }
    
}
}
