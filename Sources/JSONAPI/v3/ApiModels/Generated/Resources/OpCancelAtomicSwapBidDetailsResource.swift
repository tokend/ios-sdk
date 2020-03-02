// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCancelAtomicSwapBidDetailsResource

open class OpCancelAtomicSwapBidDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-atomic-swap-ask"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case ask
    }
    
    // MARK: Relations
    
    open var ask: AtomicSwapAskResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.ask)
    }
    
}
