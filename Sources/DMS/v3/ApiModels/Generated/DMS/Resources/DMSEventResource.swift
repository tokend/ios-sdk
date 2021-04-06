// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EventResource

extension DMS {
open class EventResource: Resource {
    
    open override class var resourceType: String {
        return "events"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case eventType
        case timestamp
        
        // relations
        case initiator
    }
    
    // MARK: Attributes
    
    open var eventType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.eventType) ?? 0
    }
    
    open var timestamp: Date {
        return self.dateOptionalValue(key: CodingKeys.timestamp) ?? Date()
    }
    
    // MARK: Relations
    
    open var initiator: DMS.UserResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.initiator)
    }
    
}
}
