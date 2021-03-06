// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DataResource

extension Invoices {
open class DataResource: Resource {
    
    open override class var resourceType: String {
        return "datas"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case securityType
        case value
        
        // relations
        case owner
    }
    
    // MARK: Attributes
    
    open var securityType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.securityType) ?? 0
    }
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
