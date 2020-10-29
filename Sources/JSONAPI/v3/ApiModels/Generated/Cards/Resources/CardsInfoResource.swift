// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InfoResource

extension Cards {
open class InfoResource: Resource {
    
    open override class var resourceType: String {
        return "cards-info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case account
        case role
        case signer
    }
    
    // MARK: Relations
    
    open var account: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var role: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.role)
    }
    
    open var signer: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.signer)
    }
    
}
}
