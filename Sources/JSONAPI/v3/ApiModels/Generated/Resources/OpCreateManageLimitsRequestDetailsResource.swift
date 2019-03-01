// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateManageLimitsRequestDetailsResource

open class OpCreateManageLimitsRequestDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-manage-limits-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        
        // relations
        case request
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var request: ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
