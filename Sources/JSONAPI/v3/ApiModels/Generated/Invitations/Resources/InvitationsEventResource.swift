// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EventResource

extension Invitations {
open class EventResource: Resource {
    
    open override class var resourceType: String {
        return "invitation-events"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case createdAt
        case details
        case signature
        case type
        
        // relations
        case aggregate
    }
    
    // MARK: Attributes
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var details: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.details)
    }
    
    open var signature: String {
        return self.stringOptionalValue(key: CodingKeys.signature) ?? ""
    }
    
    open var attributesType: Invitations.Enum? {
        return self.codableOptionalValue(key: CodingKeys.type)
    }
    
    // MARK: Relations
    
    open var aggregate: Invitations.InvitationResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.aggregate)
    }
    
}
}
