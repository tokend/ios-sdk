// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDataRemoveRequestOpResource

extension Horizon {
open class CreateDataRemoveRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-data-remove-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        
        // relations
        case data
        case owner
        case request
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
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
