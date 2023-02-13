// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SecondaryMarketResource

extension Nifty {
open class SecondaryMarketResource: Resource {
    
    open override class var resourceType: String {
        return "secondary-market"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case firstReserve
        case index
        case secondReserve
        
        // relations
        case firstAsset
        case firstBalance
        case secondAsset
        case secondBalance
    }
    
    // MARK: Attributes
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var firstReserve: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.firstReserve) ?? 0.0
    }
    
    open var index: Int32 {
        return self.int32OptionalValue(key: CodingKeys.index) ?? 0
    }
    
    open var secondReserve: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.secondReserve) ?? 0.0
    }
    
    // MARK: Relations
    
    open var firstAsset: Nifty.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.firstAsset)
    }
    
    open var firstBalance: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.firstBalance)
    }
    
    open var secondAsset: Nifty.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.secondAsset)
    }
    
    open var secondBalance: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.secondBalance)
    }
    
}
}
