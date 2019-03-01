// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageKeyValueDetailsResource

open class OpManageKeyValueDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-key-value"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case key
        case value
    }
    
    // MARK: Attributes
    
    open var action: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var key: String {
        return self.stringOptionalValue(key: CodingKeys.key) ?? ""
    }
    
    open var value: KeyValueEntryValue? {
        return self.codableOptionalValue(key: CodingKeys.value)
    }
    
}
