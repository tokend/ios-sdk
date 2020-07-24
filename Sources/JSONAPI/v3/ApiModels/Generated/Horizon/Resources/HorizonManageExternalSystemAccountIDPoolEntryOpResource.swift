// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageExternalSystemAccountIDPoolEntryOpResource

extension Horizon {
open class ManageExternalSystemAccountIDPoolEntryOpResource: BaseOperationDetailsResource {
    
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
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var create: Horizon.CreateExternalSystemPoolOp? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    open var remove: Horizon.RemoveExternalSystemPoolOp? {
        return self.codableOptionalValue(key: CodingKeys.remove)
    }
    
}
}
