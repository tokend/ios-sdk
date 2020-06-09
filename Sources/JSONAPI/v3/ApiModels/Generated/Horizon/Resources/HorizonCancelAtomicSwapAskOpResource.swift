// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CancelAtomicSwapAskOpResource

extension Horizon {
open class CancelAtomicSwapAskOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-cancel-atomic-swap-ask"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case ask
    }
    
    // MARK: Relations
    
    open var ask: Horizon.AtomicSwapAskResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.ask)
    }
    
}
}
