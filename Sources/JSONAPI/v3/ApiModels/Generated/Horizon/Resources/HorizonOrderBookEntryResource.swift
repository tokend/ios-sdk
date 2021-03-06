// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OrderBookEntryResource

extension Horizon {
open class OrderBookEntryResource: Resource {
    
    open override class var resourceType: String {
        return "order-book-entries"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case createdAt
        case cumulativeBaseAmount
        case cumulativeQuoteAmount
        case isBuy
        case price
        case quoteAmount
        
        // relations
        case baseAsset
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var cumulativeBaseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.cumulativeBaseAmount) ?? 0.0
    }
    
    open var cumulativeQuoteAmount: String {
        return self.stringOptionalValue(key: CodingKeys.cumulativeQuoteAmount) ?? ""
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    open var quoteAmount: String {
        return self.stringOptionalValue(key: CodingKeys.quoteAmount) ?? ""
    }
    
    // MARK: Relations
    
    open var baseAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var quoteAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
}
