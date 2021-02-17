// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - FriendResource

extension Friends {
open class FriendResource: Resource {
    
    open override class var resourceType: String {
        return "friend-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case newFriend
    }
    
    // MARK: Relations
    
    open var newFriend: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.newFriend)
    }
    
}
}
