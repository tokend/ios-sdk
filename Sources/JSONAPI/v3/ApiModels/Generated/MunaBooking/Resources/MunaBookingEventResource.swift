// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EventResource

extension MunaBooking {
open class EventResource: Resource {
    
    open override class var resourceType: String {
        return "events"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case endTime
        case startTime
        
        // relations
        case attendee
        case calendar
        case holder
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    // MARK: Relations
    
    open var attendee: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.attendee)
    }
    
    open var calendar: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.calendar)
    }
    
    open var holder: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.holder)
    }
    
}
}
