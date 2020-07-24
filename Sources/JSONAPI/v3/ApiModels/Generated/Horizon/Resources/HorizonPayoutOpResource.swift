// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PayoutOpResource

extension Horizon {
open class PayoutOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-payout"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case actualFee
        case actualPayoutAmount
        case expectedFee
        case maxPayoutAmount
        case minAssetHolderAmount
        case minPayoutAmount
        
        // relations
        case asset
        case sourceAccount
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var actualFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.actualFee)
    }
    
    open var actualPayoutAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.actualPayoutAmount) ?? 0.0
    }
    
    open var expectedFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.expectedFee)
    }
    
    open var maxPayoutAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxPayoutAmount) ?? 0.0
    }
    
    open var minAssetHolderAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.minAssetHolderAmount) ?? 0.0
    }
    
    open var minPayoutAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.minPayoutAmount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var sourceAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceAccount)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
