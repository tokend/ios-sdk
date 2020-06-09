// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SaleWhitelistResource

extension Horizon {
open class SaleWhitelistResource: Resource {
    
    open override class var resourceType: String {
        return "sale-whitelist"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case participant
    }
    
    // MARK: Relations
    
    open var participant: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.participant)
    }
    
}
}
