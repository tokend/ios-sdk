// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - UpdateDataOpResource

extension Horizon {
open class UpdateDataOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-update-data"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case value
        
        // relations
        case data
    }
    
    // MARK: Attributes
    
    open var value: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.value) ?? [:]
    }
    
    // MARK: Relations
    
    open var data: Horizon.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
}
}
