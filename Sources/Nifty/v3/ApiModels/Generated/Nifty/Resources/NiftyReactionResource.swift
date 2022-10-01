// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReactionResource

extension Nifty {
open class ReactionResource: Resource {
    
    open override class var resourceType: String {
        return "likes-reaction"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case reactionType
        
        // relations
        case asset
        case sale
        case saleQuoteAsset
    }
    
    // MARK: Attributes
    
    open var reactionType: String {
        return self.stringOptionalValue(key: CodingKeys.reactionType) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: Nifty.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var sale: Nifty.SaleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sale)
    }
    
    open var saleQuoteAsset: Nifty.SaleQuoteAssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.saleQuoteAsset)
    }
    
}
}
