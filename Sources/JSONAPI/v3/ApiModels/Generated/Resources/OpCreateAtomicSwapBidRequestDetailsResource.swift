// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateAtomicSwapBidRequestDetailsResource

open class OpCreateAtomicSwapBidRequestDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-atomic-swap-bid-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case creatorDetails
        
        // relations
        case ask
        case quoteAsset
        case request
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var ask: AtomicSwapAskResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.ask)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
    open var request: ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
