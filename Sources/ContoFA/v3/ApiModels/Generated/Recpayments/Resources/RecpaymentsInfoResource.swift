// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InfoResource

extension Recpayments {
open class InfoResource: Resource {
    
    open override class var resourceType: String {
        return "recurring-payments-svc-info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case accountId
        case signerPubKey
    }
    
    // MARK: Relations
    
    open var accountId: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountId)
    }
    
    open var signerPubKey: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.signerPubKey)
    }
    
}
}
