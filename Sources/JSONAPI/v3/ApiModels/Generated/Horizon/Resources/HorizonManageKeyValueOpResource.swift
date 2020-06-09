// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageKeyValueOpResource

extension Horizon {
open class ManageKeyValueOpResource: BaseOperationDetailsResource {
    
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
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var key: String {
        return self.stringOptionalValue(key: CodingKeys.key) ?? ""
    }
    
    open var value: Horizon.KeyValueEntryValue? {
        return self.codableOptionalValue(key: CodingKeys.value)
    }
    
}
}
