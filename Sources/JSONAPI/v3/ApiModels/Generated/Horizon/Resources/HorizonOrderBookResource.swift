// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OrderBookResource

extension Horizon {
open class OrderBookResource: Resource {
    
    open override class var resourceType: String {
        return "order-books"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case baseAsset
        case buyEntries
        case quoteAsset
        case sellEntries
    }
    
    // MARK: Relations
    
    open var baseAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var buyEntries: [Horizon.OrderBookEntryResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.buyEntries)
    }
    
    open var quoteAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
    open var sellEntries: [Horizon.OrderBookEntryResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.sellEntries)
    }
    
}
}
