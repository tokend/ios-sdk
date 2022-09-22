// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LpSwapOpResource

extension Horizon {
open class LpSwapOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-lp-swap"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case inAmount
        case liquidityPoolId
        case outAmount
        case swapType
        
        // relations
        case sourceInBalance
        case sourceOutBalance
    }
    
    // MARK: Attributes
    
    open var inAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.inAmount) ?? 0.0
    }
    
    open var liquidityPoolId: Int32 {
        return self.int32OptionalValue(key: CodingKeys.liquidityPoolId) ?? 0
    }
    
    open var outAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.outAmount) ?? 0.0
    }
    
    open var swapType: String {
        return self.stringOptionalValue(key: CodingKeys.swapType) ?? ""
    }
    
    // MARK: Relations
    
    open var sourceInBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceInBalance)
    }
    
    open var sourceOutBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceOutBalance)
    }
    
}
}
