// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpBindExternalSystemAccountDetailsResource

open class OpBindExternalSystemAccountDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-bind-external-system-account-id"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case externalSystemType
    }
    
    // MARK: Attributes
    
    open var externalSystemType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.externalSystemType) ?? 0
    }
    
}
