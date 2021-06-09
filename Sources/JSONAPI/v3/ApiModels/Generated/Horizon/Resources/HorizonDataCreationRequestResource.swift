// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DataCreationRequestResource

extension Horizon {
open class DataCreationRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-data-creation"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case sequenceNumber
        case type
        case value
        
        // relations
        case owner
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var sequenceNumber: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.sequenceNumber) ?? 0
    }
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
