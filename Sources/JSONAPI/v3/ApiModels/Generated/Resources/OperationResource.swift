// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OperationResource

open class OperationResource: Resource {
    
    open override class var resourceType: String {
        return "operations"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case appliedAt
        
        // relations
        case details
        case source
        case tx
    }
    
    // MARK: Attributes
    
    open var appliedAt: Date {
        return self.dateOptionalValue(key: CodingKeys.appliedAt) ?? Date()
    }
    
    // MARK: Relations
    
    open var details: OperationDetailsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.details)
    }
    
    open var source: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.source)
    }
    
    open var tx: TransactionResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.tx)
    }
    
}
