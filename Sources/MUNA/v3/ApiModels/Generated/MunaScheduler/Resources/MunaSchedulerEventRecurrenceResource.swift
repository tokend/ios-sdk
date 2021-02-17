// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EventRecurrenceResource

extension MunaScheduler {
open class EventRecurrenceResource: Resource {
    
    open override class var resourceType: String {
        return "events-recurrence"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case duration
        case maxParticipants
        case payload
        case recurrence
        
        // relations
        case calendar
        case owner
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var duration: String? {
        return self.stringOptionalValue(key: CodingKeys.duration)
    }
    
    open var maxParticipants: Int32 {
        return self.int32OptionalValue(key: CodingKeys.maxParticipants) ?? 0
    }
    
    open var payload: String {
        return self.stringOptionalValue(key: CodingKeys.payload) ?? ""
    }
    
    open var recurrence: MunaScheduler.Recurrence? {
        return self.codableOptionalValue(key: CodingKeys.recurrence)
    }
    
    // MARK: Relations
    
    open var calendar: MunaScheduler.CalendarResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.calendar)
    }
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
