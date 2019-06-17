// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ConvertedBalanceStateResource

open class ConvertedBalanceStateResource: Resource {
    
    open override class var resourceType: String {
        return "converted-balance-states"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case convertedAmounts
        case initialAmounts
        case isConverted
        case price
        
        // relations
        case balance
    }
    
    // MARK: Attributes
    
    open var convertedAmounts: BalanceStateAmounts? {
        return self.codableOptionalValue(key: CodingKeys.convertedAmounts)
    }
    
    open var initialAmounts: BalanceStateAmounts? {
        return self.codableOptionalValue(key: CodingKeys.initialAmounts)
    }
    
    open var isConverted: Bool {
        return self.boolOptionalValue(key: CodingKeys.isConverted) ?? false
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    // MARK: Relations
    
    open var balance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balance)
    }
    
}
