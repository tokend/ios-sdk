// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ExternalIdResource

extension Contoparty {
open class ExternalIdResource: Resource {
    
    open override class var resourceType: String {
        return "external-id"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case externalId
        case externalType
    }
    
    // MARK: Attributes
    
    open var externalId: String {
        return self.stringOptionalValue(key: CodingKeys.externalId) ?? ""
    }
    
    open var externalType: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.externalType)
    }
    
}
}
