// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CheckSaleStateOpResource

extension Horizon {
open class CheckSaleStateOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-check-sale-state"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case effect
        
        // relations
        case sale
    }
    
    // MARK: Attributes
    
    open var effect: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.effect)
    }
    
    // MARK: Relations
    
    open var sale: Horizon.SaleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sale)
    }
    
}
}
