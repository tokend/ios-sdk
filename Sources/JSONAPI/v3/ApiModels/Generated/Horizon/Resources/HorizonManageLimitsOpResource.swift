// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageLimitsOpResource

extension Horizon {
open class ManageLimitsOpResource: Resource {
    
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
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var create: Horizon.ManageLimitsCreationOp? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    open var remove: Horizon.ManageLimitsRemovalOp? {
        return self.codableOptionalValue(key: CodingKeys.remove)
    }
    
}
}
