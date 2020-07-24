// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReviewRequestOpResource

extension Horizon {
open class ReviewRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-review-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case addedTasks
        case externalDetails
        case isFulfilled
        case reason
        case removedTasks
        case requestHash
        case requestId
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var addedTasks: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.addedTasks) ?? 0
    }
    
    open var externalDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.externalDetails) ?? [:]
    }
    
    open var isFulfilled: Bool {
        return self.boolOptionalValue(key: CodingKeys.isFulfilled) ?? false
    }
    
    open var reason: String {
        return self.stringOptionalValue(key: CodingKeys.reason) ?? ""
    }
    
    open var removedTasks: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.removedTasks) ?? 0
    }
    
    open var requestHash: String {
        return self.stringOptionalValue(key: CodingKeys.requestHash) ?? ""
    }
    
    open var requestId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.requestId) ?? 0
    }
    
}
}
