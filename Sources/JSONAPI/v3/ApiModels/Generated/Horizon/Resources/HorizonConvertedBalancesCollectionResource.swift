// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ConvertedBalancesCollectionResource

extension Horizon {
open class ConvertedBalancesCollectionResource: Resource {
    
    open override class var resourceType: String {
        return "converted-balances-collections"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case asset
        case states
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var states: [Horizon.ConvertedBalanceStateResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.states)
    }
    
}
}
