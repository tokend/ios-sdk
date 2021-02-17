// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - FreeBusyResource

extension MunaScheduler {
open class FreeBusyResource: Resource {
    
    open override class var resourceType: String {
        return "freebusy"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case endTime
        case participants
        case payload
        case startTime
        
        // relations
        case events
    }
    
    // MARK: Attributes
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var participants: Int32 {
        return self.int32OptionalValue(key: CodingKeys.participants) ?? 0
    }
    
    open var payload: String {
        return self.stringOptionalValue(key: CodingKeys.payload) ?? ""
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    // MARK: Relations
    
    open var events: [MunaScheduler.EventResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.events)
    }
    
}
}
