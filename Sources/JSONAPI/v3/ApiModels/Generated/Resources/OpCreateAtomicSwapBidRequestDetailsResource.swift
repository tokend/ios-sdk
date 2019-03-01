// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateAtomicSwapBidRequestDetailsResource

open class OpCreateAtomicSwapBidRequestDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-aswap-bid-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case details
        
        // relations
        case baseBalance
        case quoteAssets
        case request
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    // MARK: Relations
    
    open var baseBalance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseBalance)
    }
    
    open var quoteAssets: [AssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
    open var request: ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
