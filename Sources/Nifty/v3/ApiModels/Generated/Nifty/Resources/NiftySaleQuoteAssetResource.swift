// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SaleQuoteAssetResource

extension Nifty {
open class SaleQuoteAssetResource: Resource {
    
    open override class var resourceType: String {
        return "sale-quote-assets"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case currentCap
        case hardCap
        case price
        case softCap
        case totalCurrentCap
        
        // relations
        case asset
    }
    
    // MARK: Attributes
    
    open var currentCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.currentCap) ?? 0.0
    }
    
    open var hardCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.hardCap) ?? 0.0
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    open var softCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.softCap) ?? 0.0
    }
    
    open var totalCurrentCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.totalCurrentCap) ?? 0.0
    }
    
    // MARK: Relations
    
    open var asset: Nifty.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
}
