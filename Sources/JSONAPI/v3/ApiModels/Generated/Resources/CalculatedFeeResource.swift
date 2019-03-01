// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CalculatedFeeResource

open class CalculatedFeeResource: Resource {
    
    open override class var resourceType: String {
        return "calculated-fee"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case calculatedPercent
        case fixed
    }
    
    // MARK: Attributes
    
    open var calculatedPercent: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.calculatedPercent) ?? 0.0
    }
    
    open var fixed: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.fixed) ?? 0.0
    }
    
}
