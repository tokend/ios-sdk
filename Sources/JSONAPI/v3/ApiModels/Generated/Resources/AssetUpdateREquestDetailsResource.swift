// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AssetUpdateREquestDetailsResource

open class AssetUpdateREquestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-asset-update"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case policies
        
        // relations
        case asset
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var policies: Int32 {
        return self.int32OptionalValue(key: CodingKeys.policies) ?? 0
    }
    
    // MARK: Relations
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
