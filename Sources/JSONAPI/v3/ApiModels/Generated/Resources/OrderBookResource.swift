// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OrderBookResource

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
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var buyEntries: [OrderBookEntryResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.buyEntries)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
    open var sellEntries: [OrderBookEntryResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.sellEntries)
    }
    
}
