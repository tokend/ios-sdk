// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CardBalanceResource

extension Cards {
open class CardBalanceResource: Resource {
    
    open override class var resourceType: String {
        return "card-balance"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case asset
        case card
    }
    
    // MARK: Relations
    
    open var asset: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var card: Cards.CardResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.card)
    }
    
}
}
