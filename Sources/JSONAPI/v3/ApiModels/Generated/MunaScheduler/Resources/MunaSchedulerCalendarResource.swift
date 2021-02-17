// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CalendarResource

extension MunaScheduler {
open class CalendarResource: Resource {
    
    open override class var resourceType: String {
        return "calendars"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case capacity
        case details
        
        // relations
        case events
        case owner
        case recurrences
    }
    
    // MARK: Attributes
    
    open var capacity: Int32 {
        return self.int32OptionalValue(key: CodingKeys.capacity) ?? 0
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    // MARK: Relations
    
    open var events: [MunaScheduler.EventResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.events)
    }
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var recurrences: [MunaScheduler.EventRecurrenceResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.recurrences)
    }
    
}
}
