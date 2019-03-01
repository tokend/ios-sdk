// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageLimitsDetailsResource

open class OpManageLimitsDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-limits"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case create
        case remove
    }
    
    // MARK: Attributes
    
    open var action: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var create: LimitsCreation? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    open var remove: LimitsRemoval? {
        return self.codableOptionalValue(key: CodingKeys.remove)
    }
    
}
