// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - BookingResource

extension MunaBooking {
open class BookingResource: Resource {
    
    open override class var resourceType: String {
        return "bookings"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case cancelTill
        case confirmationType
        case createdAt
        case details
        case endTime
        case lockTime
        case participants
        case payload
        case reference
        case startTime
        case state
        
        // relations
        case asset
        case event
        case owner
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var cancelTill: Date {
        return self.dateOptionalValue(key: CodingKeys.cancelTill) ?? Date()
    }
    
    open var confirmationType: MunaBooking.Enum? {
        return self.codableOptionalValue(key: CodingKeys.confirmationType)
    }
    
    open var createdAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.createdAt)
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var lockTime: Date? {
        return self.dateOptionalValue(key: CodingKeys.lockTime)
    }
    
    open var participants: Int32 {
        return self.int32OptionalValue(key: CodingKeys.participants) ?? 0
    }
    
    open var payload: String {
        return self.stringOptionalValue(key: CodingKeys.payload) ?? ""
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    open var state: MunaBooking.Enum? {
        return self.codableOptionalValue(key: CodingKeys.state)
    }
    
    // MARK: Relations
    
    open var asset: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var event: MunaBooking.EventResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.event)
    }
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
}
