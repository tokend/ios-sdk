// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDataCreationRequestOpResource

extension Horizon {
open class CreateDataCreationRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-data-creation-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case type
        case value
        
        // relations
        case owner
        case request
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
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
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
