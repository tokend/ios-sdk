// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CloseSwapOpResource

extension Horizon {
open class CloseSwapOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-close-swap"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case secret
        
        // relations
        case swap
    }
    
    // MARK: Attributes
    
    open var secret: String? {
        return self.stringOptionalValue(key: CodingKeys.secret)
    }
    
    // MARK: Relations
    
    open var swap: Horizon.SwapResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.swap)
    }
    
}
}
