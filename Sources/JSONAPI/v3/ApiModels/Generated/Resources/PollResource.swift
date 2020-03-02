// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PollResource

open class PollResource: Resource {
    
    open override class var resourceType: String {
        return "polls"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case endTime
        case numberOfChoices
        case permissionType
        case pollData
        case pollState
        case startTime
        case voteConfirmationRequired
        
        // relations
        case owner
        case participation
        case resultProvider
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var numberOfChoices: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.numberOfChoices) ?? 0
    }
    
    open var permissionType: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.permissionType) ?? 0
    }
    
    open var pollData: PollData? {
        return self.codableOptionalValue(key: CodingKeys.pollData)
    }
    
    open var pollState: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.pollState)
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    open var voteConfirmationRequired: Bool {
        return self.boolOptionalValue(key: CodingKeys.voteConfirmationRequired) ?? false
    }
    
    // MARK: Relations
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var participation: PollParticipationResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.participation)
    }
    
    open var resultProvider: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.resultProvider)
    }
    
}
