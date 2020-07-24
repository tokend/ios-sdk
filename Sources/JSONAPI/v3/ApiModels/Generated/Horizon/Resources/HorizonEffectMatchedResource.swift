// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EffectMatchedResource

extension Horizon {
open class EffectMatchedResource: BaseEffectResource {
    
    open override class var resourceType: String {
        return "effects-matched"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case charged
        case funded
        case offerId
        case orderBookId
        case price
    }
    
    // MARK: Attributes
    
    open var charged: Horizon.ParticularBalanceChangeEffect? {
        return self.codableOptionalValue(key: CodingKeys.charged)
    }
    
    open var funded: Horizon.ParticularBalanceChangeEffect? {
        return self.codableOptionalValue(key: CodingKeys.funded)
    }
    
    open var offerId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.offerId) ?? 0
    }
    
    open var orderBookId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.orderBookId) ?? 0
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
}
}
