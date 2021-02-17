// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BusinessResource

extension MunaBooking {
open class BusinessResource: Resource {
    
    open override class var resourceType: String {
        return "booking-businesses"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case bookingDetails
        case details
        case name
        case workDays
        
        // relations
        case calendar
        case owner
    }
    
    // MARK: Attributes
    
    open var bookingDetails: MunaBooking.BookingDetails? {
        return self.codableOptionalValue(key: CodingKeys.bookingDetails)
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var workDays: [String: MunaBooking.WorkHours]? {
        return self.codableOptionalValue(key: CodingKeys.workDays)
    }
    
    // MARK: Relations
    
    open var calendar: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.calendar)
    }
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
