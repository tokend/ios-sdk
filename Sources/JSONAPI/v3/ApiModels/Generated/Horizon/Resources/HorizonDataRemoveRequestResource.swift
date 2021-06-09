// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DataRemoveRequestResource

extension Horizon {
open class DataRemoveRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-data-remove"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case sequenceNumber
        
        // relations
        case data
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var sequenceNumber: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.sequenceNumber) ?? 0
    }
    
    // MARK: Relations
    
    open var data: Horizon.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
}
}
