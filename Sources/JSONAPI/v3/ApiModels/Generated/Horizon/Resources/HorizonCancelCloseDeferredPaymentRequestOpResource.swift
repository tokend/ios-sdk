// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelCloseDeferredPaymentRequestOpResource

extension Horizon {
open class CancelCloseDeferredPaymentRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-close-deferred-payment-request"
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
