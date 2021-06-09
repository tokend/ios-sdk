// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RemoveDataOpResource

extension Horizon {
open class RemoveDataOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-remove-data"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case data
        case owner
    }
    
    // MARK: Relations
    
    open var data: Horizon.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
