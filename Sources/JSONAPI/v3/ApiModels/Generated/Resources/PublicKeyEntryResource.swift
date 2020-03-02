// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PublicKeyEntryResource

open class PublicKeyEntryResource: Resource {
    
    open override class var resourceType: String {
        return "public-key-entries"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case accounts
    }
    
    // MARK: Relations
    
    open var accounts: [AccountResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.accounts)
    }
    
}
