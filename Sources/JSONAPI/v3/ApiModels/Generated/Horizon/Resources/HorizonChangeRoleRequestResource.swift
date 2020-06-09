// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ChangeRoleRequestResource

extension Horizon {
open class ChangeRoleRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-change-role"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountRoleToSet
        case creatorDetails
        case sequenceNumber
        
        // relations
        case accountToUpdateRole
    }
    
    // MARK: Attributes
    
    open var accountRoleToSet: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.accountRoleToSet) ?? 0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var sequenceNumber: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.sequenceNumber) ?? 0
    }
    
    // MARK: Relations
    
    open var accountToUpdateRole: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountToUpdateRole)
    }
    
}
}
