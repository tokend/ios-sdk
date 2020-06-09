// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BalancesStatisticResource

extension Horizon {
open class BalancesStatisticResource: Resource {
    
    open override class var resourceType: String {
        return "balances-statistic"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case asset
        case availableAmount
        case closedSalesAmount
        case fullAmount
        case pendingSalesAmount
    }
    
    // MARK: Attributes
    
    open var asset: String {
        return self.stringOptionalValue(key: CodingKeys.asset) ?? ""
    }
    
    open var availableAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.availableAmount) ?? 0.0
    }
    
    open var closedSalesAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.closedSalesAmount) ?? 0.0
    }
    
    open var fullAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.fullAmount) ?? 0.0
    }
    
    open var pendingSalesAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.pendingSalesAmount) ?? 0.0
    }
    
}
}
