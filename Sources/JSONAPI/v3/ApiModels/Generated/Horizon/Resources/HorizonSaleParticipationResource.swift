// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SaleParticipationResource

extension Horizon {
open class SaleParticipationResource: Resource {
    
    open override class var resourceType: String {
        return "sale-participation"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        
        // relations
        case baseAsset
        case participant
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var participant: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.participant)
    }
    
    open var quoteAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
}
