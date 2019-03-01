// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageBalanceDetailsResource

open class OpManageBalanceDetailsResource: OperationDetailsResource {
    
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
    
    open var action: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var balanceAddress: String {
        return self.stringOptionalValue(key: CodingKeys.balanceAddress) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var destinationAccount: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationAccount)
    }
    
}
