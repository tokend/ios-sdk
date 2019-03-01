// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SignerResource

open class SignerResource: Resource {
    
    open override class var resourceType: String {
        return "signers"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case identity
        case weight
        
        // relations
        case account
        case role
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var identity: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.identity) ?? 0
    }
    
    open var weight: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.weight) ?? 0
    }
    
    // MARK: Relations
    
    open var account: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var role: SignerRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
}
