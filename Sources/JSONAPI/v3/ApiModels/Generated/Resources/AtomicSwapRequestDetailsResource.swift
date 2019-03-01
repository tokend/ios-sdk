// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AtomicSwapRequestDetailsResource

open class AtomicSwapRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-atomic-swap"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case creatorDetails
        
        // relations
        case bid
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
    
    open var bid: ASwapBidRequestDetailsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.bid)
    }
    
    open var quoteAsset: QuoteAssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
