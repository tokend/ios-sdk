// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpPayoutDetailsResource

open class OpPayoutDetailsResource: OperationDetailsResource {
    
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
    
    open var actualFee: Fee? {
        return self.codableOptionalValue(key: CodingKeys.actualFee)
    }
    
    open var actualPayoutAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.actualPayoutAmount) ?? 0.0
    }
    
    open var expectedFee: Fee? {
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
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var sourceAccount: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceAccount)
    }
    
    open var sourceBalance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
