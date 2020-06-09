// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageSignerOpResource

extension Horizon {
open class ManageSignerOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "base-manage-signer-op"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case identity
        case weight
        
        // relations
        case role
        case signer
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
    
    open var role: Horizon.SignerRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
    open var signer: Horizon.SignerResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.signer)
    }
    
}
}
