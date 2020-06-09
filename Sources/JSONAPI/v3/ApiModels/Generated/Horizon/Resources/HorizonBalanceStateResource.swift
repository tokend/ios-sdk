// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BalanceStateResource

extension Horizon {
open class BalanceStateResource: Resource {
    
    open override class var resourceType: String {
        return "balances-state"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case available
        case locked
    }
    
    // MARK: Attributes
    
    open var available: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.available) ?? 0.0
    }
    
    open var locked: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.locked) ?? 0.0
    }
    
}
}
