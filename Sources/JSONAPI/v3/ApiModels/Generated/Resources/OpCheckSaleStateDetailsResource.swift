// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCheckSaleStateDetailsResource

open class OpCheckSaleStateDetailsResource: OperationDetailsResource {
    
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
    
    open var effect: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.effect)
    }
    
    // MARK: Relations
    
    open var sale: SaleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sale)
    }
    
}
