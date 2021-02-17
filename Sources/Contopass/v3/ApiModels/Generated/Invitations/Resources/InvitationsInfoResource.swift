// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InfoResource

extension Invitations {
open class InfoResource: Resource {
    
    open override class var resourceType: String {
        return "invitations-info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case accountId
    }
    
    // MARK: Relations
    
    open var accountId: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountId)
    }
    
}
}
