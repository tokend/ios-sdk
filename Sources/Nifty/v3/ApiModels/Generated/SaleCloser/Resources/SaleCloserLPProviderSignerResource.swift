// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LPProviderSignerResource

extension SaleCloser {
open class LPProviderSignerResource: Resource {
    
    open override class var resourceType: String {
        return "lp-provider-signer"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case roleId
    }
    
    // MARK: Attributes
    
    open var roleId: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.roleId) ?? 0
    }
    
}
}
