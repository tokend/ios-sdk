// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDataOpResource

extension Horizon {
open class CreateDataOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-data"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case type
        case value
        
        // relations
        case owner
    }
    
    // MARK: Attributes
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
