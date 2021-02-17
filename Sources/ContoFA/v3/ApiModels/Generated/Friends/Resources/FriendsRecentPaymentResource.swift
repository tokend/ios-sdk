// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RecentPaymentResource

extension Friends {
open class RecentPaymentResource: Resource {
    
    open override class var resourceType: String {
        return "recent-payments"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case destination
        case destinationCard
        case source
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
