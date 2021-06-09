// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelDataRemoveRequestOpResource

extension Horizon {
open class CancelDataRemoveRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-data-remove-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case request
    }
    
    // MARK: Relations
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
