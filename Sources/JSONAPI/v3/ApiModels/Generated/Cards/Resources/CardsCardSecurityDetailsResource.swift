// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CardSecurityDetailsResource

extension Cards {
open class CardSecurityDetailsResource: Resource {
    
    open override class var resourceType: String {
        return "cards-security-details"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case card
    }
    
    // MARK: Relations
    
    open var card: Cards.CardResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.card)
    }
    
}
}
