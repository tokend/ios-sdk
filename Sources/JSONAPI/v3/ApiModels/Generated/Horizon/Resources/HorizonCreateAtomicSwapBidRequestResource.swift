// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateAtomicSwapBidRequestResource

extension Horizon {
open class CreateAtomicSwapBidRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-atomic-swap-bid"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case creatorDetails
        
        // relations
        case ask
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var ask: Horizon.AtomicSwapAskResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.ask)
    }
    
    open var quoteAsset: Horizon.QuoteAssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
}
