// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageCreatePollRequestOpResource

extension Horizon {
open class ManageCreatePollRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-create-poll-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case create
        
        // relations
        case request
        case resultProvider
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var create: Horizon.CreatePollRequestOp? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    // MARK: Relations
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
    open var resultProvider: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.resultProvider)
    }
    
}
}
