// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LimitsUpdateRequestDetailsResource

open class LimitsUpdateRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-limits-update"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
}
