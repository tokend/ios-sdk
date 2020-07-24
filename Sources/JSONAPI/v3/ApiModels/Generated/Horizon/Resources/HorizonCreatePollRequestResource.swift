// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreatePollRequestResource

extension Horizon {
open class CreatePollRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-create-poll"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case endTime
        case numberOfChoices
        case permissionType
        case pollData
        case startTime
        case voteConfirmationRequired
        
        // relations
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
    
    open var pollData: Horizon.PollData? {
        return self.codableOptionalValue(key: CodingKeys.pollData)
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    open var voteConfirmationRequired: Bool {
        return self.boolOptionalValue(key: CodingKeys.voteConfirmationRequired) ?? false
    }
    
    // MARK: Relations
    
    open var resultProvider: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.resultProvider)
    }
    
}
}
