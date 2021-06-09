// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DataUpdateRequestResource

extension Horizon {
open class DataUpdateRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-data-update"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case sequenceNumber
        case value
        
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
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var data: Horizon.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
}
}
