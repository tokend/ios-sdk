// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - QuoteAssetResource

extension Horizon {
open class QuoteAssetResource: Resource {
    
    open override class var resourceType: String {
        return "quote-assets"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case currentCap
        case hardCap
        case price
        case softCap
        case totalCurrentCap
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
    
    open var softCap: Decimal? {
        return self.decimalOptionalValue(key: CodingKeys.softCap)
    }
    
    open var totalCurrentCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.totalCurrentCap) ?? 0.0
    }
    
}
}
