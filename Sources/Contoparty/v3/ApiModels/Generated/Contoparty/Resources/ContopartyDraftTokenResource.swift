// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DraftTokenResource

extension Contoparty {
open class DraftTokenResource: Resource {
    
    open override class var resourceType: String {
        return "draft-tokens"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case assetCode
        case creator
        case details
        case tokenType
        case type
    }
    
    // MARK: Attributes
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var creator: String {
        return self.stringOptionalValue(key: CodingKeys.creator) ?? ""
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var tokenType: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.tokenType)
    }
    
    open var attributesType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.type) ?? 0
    }
    
}
}
