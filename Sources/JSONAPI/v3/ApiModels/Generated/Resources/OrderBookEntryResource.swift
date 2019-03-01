// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OrderBookEntryResource

open class OrderBookEntryResource: Resource {
    
    open override class var resourceType: String {
        return "order-book-entries"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case createdAt
        case isBuy
        case price
        case quoteAmount
        
        // relations
        case baseAsset
        case offer
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    open var quoteAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.quoteAmount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var offer: OfferResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.offer)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
