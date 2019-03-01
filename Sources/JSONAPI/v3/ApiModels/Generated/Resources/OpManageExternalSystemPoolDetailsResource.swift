// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageExternalSystemPoolDetailsResource

open class OpManageExternalSystemPoolDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-external-system-account-id-pool-entry"
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
    
    open var create: ExternalSystemPoolCreation? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    open var remove: ExternalSystemPoolRemoval? {
        return self.codableOptionalValue(key: CodingKeys.remove)
    }
    
}
