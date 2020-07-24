// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageBalanceOpResource

extension Horizon {
open class ManageBalanceOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-balance"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case balanceAddress
        
        // relations
        case asset
        case destinationAccount
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var balanceAddress: String {
        return self.stringOptionalValue(key: CodingKeys.balanceAddress) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var destinationAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationAccount)
    }
    
}
}
