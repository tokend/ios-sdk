// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AtomicSwapAskResource

open class AtomicSwapAskResource: Resource {
    
    open override class var resourceType: String {
        return "atomic-swap-ask"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case availableAmount
        case createdAt
        case details
        case isCanceled
        case lockedAmount
        
        // relations
        case baseAsset
        case baseBalance
        case owner
        case quoteAssets
    }
    
    // MARK: Attributes
    
    open var availableAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.availableAmount) ?? 0.0
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var isCanceled: Bool {
        return self.boolOptionalValue(key: CodingKeys.isCanceled) ?? false
    }
    
    open var lockedAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.lockedAmount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var baseBalance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseBalance)
    }
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var quoteAssets: [QuoteAssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
}
