// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LpManageLiquidityOpResource

extension Horizon {
open class LpManageLiquidityOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "base-lp-manage-liquidity-op"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case firstAssetAmount
        case liquidityPoolId
        case lpTokensAmount
        case secondAssetAmount
        
        // relations
        case firstBalance
        case secondBalance
    }
    
    // MARK: Attributes
    
    open var firstAssetAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.firstAssetAmount) ?? 0.0
    }
    
    open var liquidityPoolId: Int32 {
        return self.int32OptionalValue(key: CodingKeys.liquidityPoolId) ?? 0
    }
    
    open var lpTokensAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.lpTokensAmount) ?? 0.0
    }
    
    open var secondAssetAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.secondAssetAmount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var firstBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.firstBalance)
    }
    
    open var secondBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.secondBalance)
    }
    
}
}
