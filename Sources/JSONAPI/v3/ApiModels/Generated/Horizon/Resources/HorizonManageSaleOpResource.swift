// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageSaleOpResource

extension Horizon {
open class ManageSaleOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-sale"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case saleId
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var saleId: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.saleId) ?? 0
    }
    
}
}
