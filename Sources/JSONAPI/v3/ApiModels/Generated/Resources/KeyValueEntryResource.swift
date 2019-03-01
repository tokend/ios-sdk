// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - KeyValueEntryResource

open class KeyValueEntryResource: Resource {
    
    open override class var resourceType: String {
        return "key-value-entries"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case value
    }
    
    // MARK: Attributes
    
    open var value: KeyValueEntryValue? {
        return self.codableOptionalValue(key: CodingKeys.value)
    }
    
}
