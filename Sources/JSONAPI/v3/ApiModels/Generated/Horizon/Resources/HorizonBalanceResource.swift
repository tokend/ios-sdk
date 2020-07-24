// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BalanceResource

extension Horizon {
open class BalanceResource: Resource {
    
    open override class var resourceType: String {
        return "balances"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case asset
        case owner
        case state
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var owner: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var state: Horizon.BalanceStateResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.state)
    }
    
}
}
