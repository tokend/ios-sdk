// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDraftTokenResource

extension Contoparty {
open class CreateDraftTokenResource: Resource {
    
    open override class var resourceType: String {
        return "create-draft-token"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case assetCode
        case creator
        case details
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
    
    open var attributesType: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.type)
    }
    
}
}
