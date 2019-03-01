// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCancelAtomicSwapBidDetailsResource

open class OpCancelAtomicSwapBidDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-aswap-bid"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case bid
    }
    
    // MARK: Relations
    
    open var bid: ASwapBidRequestDetailsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.bid)
    }
    
}
