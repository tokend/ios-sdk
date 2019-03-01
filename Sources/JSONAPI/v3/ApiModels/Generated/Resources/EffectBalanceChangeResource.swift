// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EffectBalanceChangeResource

open class EffectBalanceChangeResource: EffectResource {
    
    open override class var resourceType: String {
        return "effects-balance-change"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case fee
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var fee: Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
}
