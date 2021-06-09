// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDataUpdateRequestOpResource

extension Horizon {
open class CreateDataUpdateRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-data-update-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case value
        
        // relations
        case data
        case owner
        case request
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var data: Horizon.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
