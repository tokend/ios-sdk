// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BalanceResource

open class BalanceResource: Resource {
    
    open override class var resourceType: String {
        return "balances"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case asset
        case state
    }
    
    // MARK: Relations
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var state: BalanceStateResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.state)
    }
    
}
