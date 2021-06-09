// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelDataUpdateRequestOpResource

extension Horizon {
open class CancelDataUpdateRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-data-update-request"
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
