// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LiquidityPoolResource

extension Horizon {
open class LiquidityPoolResource: Resource {
    
    open override class var resourceType: String {
        return "liquidity-pools"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case firstReserve
        case lpTokensAmount
        case secondReserve
        
        // relations
        case firstAsset
        case firstBalance
        case lpTokensAsset
        case secondAsset
        case secondBalance
    }
    
    // MARK: Attributes
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var firstReserve: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.firstReserve) ?? 0.0
    }
    
    open var lpTokensAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.lpTokensAmount) ?? 0.0
    }
    
    open var secondReserve: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.secondReserve) ?? 0.0
    }
    
    // MARK: Relations
    
    open var firstAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.firstAsset)
    }
    
    open var firstBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.firstBalance)
    }
    
    open var lpTokensAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.lpTokensAsset)
    }
    
    open var secondAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.secondAsset)
    }
    
    open var secondBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.secondBalance)
    }
    
}
}
