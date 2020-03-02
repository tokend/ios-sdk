// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AssetPairResource

open class AssetPairResource: Resource {
    
    open override class var resourceType: String {
        return "asset-pairs"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case maxPriceStep
        case physicalPriceCorrection
        case policies
        case price
        
        // relations
        case baseAsset
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var maxPriceStep: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxPriceStep) ?? 0.0
    }
    
    open var physicalPriceCorrection: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.physicalPriceCorrection) ?? 0.0
    }
    
    open var policies: XdrEnumBitmask? {
        return self.codableOptionalValue(key: CodingKeys.policies)
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
