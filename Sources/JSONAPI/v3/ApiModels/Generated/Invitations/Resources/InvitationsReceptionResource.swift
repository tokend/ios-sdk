// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReceptionResource

extension Invitations {
open class ReceptionResource: Resource {
    
    open override class var resourceType: String {
        return "receptions"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case receptionist
    }
    
    // MARK: Relations
    
    open var receptionist: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.receptionist)
    }
    
}
}
