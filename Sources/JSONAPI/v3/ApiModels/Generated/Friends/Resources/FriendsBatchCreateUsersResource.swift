// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BatchCreateUsersResource

extension Friends {
open class BatchCreateUsersResource: Resource {
    
    open override class var resourceType: String {
        return "batch-create-users-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case identities
    }
    
    // MARK: Relations
    
    open var identities: [Resource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.identities)
    }
    
}
}
