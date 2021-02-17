// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RecordPaymentResource

extension Friends {
open class RecordPaymentResource: Resource {
    
    open override class var resourceType: String {
        return "record-payment-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case createdAt
        
        // relations
        case destination
        case destinationCard
        case source
    }
    
    // MARK: Attributes
    
    open var createdAt: Int64 {
        return self.int64OptionalValue(key: CodingKeys.createdAt) ?? 0
    }
    
    // MARK: Relations
    
    open var destination: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destination)
    }
    
    open var destinationCard: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationCard)
    }
    
    open var source: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.source)
    }
    
}
}
