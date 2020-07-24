// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AtomicSwapQuoteAssetResource

extension Horizon {
open class AtomicSwapQuoteAssetResource: Resource {
    
    open override class var resourceType: String {
        return "atomic-swap-quote-assets"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case price
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    open var quoteAsset: String {
        return self.stringOptionalValue(key: CodingKeys.quoteAsset) ?? ""
    }
    
}
}
