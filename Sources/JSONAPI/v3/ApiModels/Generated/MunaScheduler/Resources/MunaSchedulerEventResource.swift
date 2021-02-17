// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EventResource

extension MunaScheduler {
open class EventResource: Resource {
    
    open override class var resourceType: String {
        return "events"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case endTime
        case lockTime
        case maxParticipants
        case participants
        case payload
        case startTime
        case state
        
        // relations
        case attendee
        case calendar
        case holder
        case recurrence
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var endTime: Date? {
        return self.dateOptionalValue(key: CodingKeys.endTime)
    }
    
    open var lockTime: Date? {
        return self.dateOptionalValue(key: CodingKeys.lockTime)
    }
    
    open var maxParticipants: Int32 {
        return self.int32OptionalValue(key: CodingKeys.maxParticipants) ?? 0
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
    
    open var state: Int32 {
        return self.int32OptionalValue(key: CodingKeys.state) ?? 0
    }
    
    // MARK: Relations
    
    open var attendee: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.attendee)
    }
    
    open var calendar: MunaScheduler.CalendarResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.calendar)
    }
    
    open var holder: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.holder)
    }
    
    open var recurrence: MunaScheduler.EventRecurrenceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.recurrence)
    }
    
}
}
