// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelDeferredPaymentCreationRequestOpResource

extension Horizon {
open class CancelDeferredPaymentCreationRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-deferred-payment-creation-request"
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
