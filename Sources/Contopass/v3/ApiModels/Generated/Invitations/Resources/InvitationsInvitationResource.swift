// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InvitationResource

extension Invitations {
open class InvitationResource: Resource {
    
    open override class var resourceType: String {
        return "invitations"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case acceptedAt
        case cancelledAt
        case createdAt
        case details
        case finalState
        case from
        case holdsAllowed
        case holdsLeft
        case paidAt
        case reference
        case state
        case to
        case updatedAt
        case waitUntil
        
        // relations
        case data
        case guest
        case host
        case place
    }
    
    // MARK: Attributes
    
    open var acceptedAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.acceptedAt)
    }
    
    open var cancelledAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.cancelledAt)
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var finalState: Invitations.Enum? {
        return self.codableOptionalValue(key: CodingKeys.finalState)
    }
    
    open var from: Date {
        return self.dateOptionalValue(key: CodingKeys.from) ?? Date()
    }
    
    open var holdsAllowed: Int32 {
        return self.int32OptionalValue(key: CodingKeys.holdsAllowed) ?? 0
    }
    
    open var holdsLeft: Int32 {
        return self.int32OptionalValue(key: CodingKeys.holdsLeft) ?? 0
    }
    
    open var paidAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.paidAt)
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    open var state: Invitations.Enum? {
        return self.codableOptionalValue(key: CodingKeys.state)
    }
    
    open var to: Date {
        return self.dateOptionalValue(key: CodingKeys.to) ?? Date()
    }
    
    open var updatedAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.updatedAt)
    }
    
    open var waitUntil: Date? {
        return self.dateOptionalValue(key: CodingKeys.waitUntil)
    }
    
    // MARK: Relations
    
    open var data: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
    open var guest: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.guest)
    }
    
    open var host: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.host)
    }
    
    open var place: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.place)
    }
    
}
}
