// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TransactionResource

extension Contoparty {
open class TransactionResource: Resource {
    
    open override class var resourceType: String {
        return "transactions-bp"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case envelope
    }
    
    // MARK: Attributes
    
    open var envelope: String {
        return self.stringOptionalValue(key: CodingKeys.envelope) ?? ""
    }
    
}
}
