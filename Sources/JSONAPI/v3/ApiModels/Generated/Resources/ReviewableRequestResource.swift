// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReviewableRequestResource

open class ReviewableRequestResource: Resource {
    
    open override class var resourceType: String {
        return "requests"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case allTasks
        case createdAt
        case externalDetails
        case hash
        case pendingTasks
        case reference
        case rejectReason
        case state
        case stateI
        case updatedAt
        case xdrType
        
        // relations
        case requestDetails
        case requestor
        case reviewer
    }
    
    // MARK: Attributes
    
    open var allTasks: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.allTasks) ?? 0
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var externalDetails: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.externalDetails)
    }
    
    open var hash: String {
        return self.stringOptionalValue(key: CodingKeys.hash) ?? ""
    }
    
    open var pendingTasks: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.pendingTasks) ?? 0
    }
    
    open var reference: String? {
        return self.stringOptionalValue(key: CodingKeys.reference)
    }
    
    open var rejectReason: String {
        return self.stringOptionalValue(key: CodingKeys.rejectReason) ?? ""
    }
    
    open var state: String {
        return self.stringOptionalValue(key: CodingKeys.state) ?? ""
    }
    
    open var stateI: Int32 {
        return self.int32OptionalValue(key: CodingKeys.stateI) ?? 0
    }
    
    open var updatedAt: Date {
        return self.dateOptionalValue(key: CodingKeys.updatedAt) ?? Date()
    }
    
    open var xdrType: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.xdrType)
    }
    
    // MARK: Relations
    
    open var requestDetails: RequestDetailsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.requestDetails)
    }
    
    open var requestor: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.requestor)
    }
    
    open var reviewer: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.reviewer)
    }
    
}
