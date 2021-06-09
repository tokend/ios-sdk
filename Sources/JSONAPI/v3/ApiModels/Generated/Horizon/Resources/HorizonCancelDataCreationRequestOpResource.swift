// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelDataCreationRequestOpResource

extension Horizon {
open class CancelDataCreationRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-data-creation-request"
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
