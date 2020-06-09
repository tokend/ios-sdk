// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateChangeRoleRequestOpResource

extension Horizon {
open class CreateChangeRoleRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-change-role-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case allTasks
        case creatorDetails
        
        // relations
        case accountToUpdateRole
        case request
        case roleToSet
    }
    
    // MARK: Attributes
    
    open var allTasks: UInt32? {
        return self.uint32OptionalValue(key: CodingKeys.allTasks)
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var accountToUpdateRole: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountToUpdateRole)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
    open var roleToSet: Horizon.AccountRoleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.roleToSet)
    }
    
}
}
