// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - VerificationResource

extension MunaTestResults {
open class VerificationResource: Resource {
    
    open override class var resourceType: String {
        return "verifications"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case date
        case isAccepted
        case location
        case participant
        case rejectReason
        
        // relations
        case creator
    }
    
    // MARK: Attributes
    
    open var date: Date {
        return self.dateOptionalValue(key: CodingKeys.date) ?? Date()
    }
    
    open var isAccepted: Bool {
        return self.boolOptionalValue(key: CodingKeys.isAccepted) ?? false
    }
    
    open var location: String {
        return self.stringOptionalValue(key: CodingKeys.location) ?? ""
    }
    
    open var participant: String {
        return self.stringOptionalValue(key: CodingKeys.participant) ?? ""
    }
    
    open var rejectReason: String {
        return self.stringOptionalValue(key: CodingKeys.rejectReason) ?? ""
    }
    
    // MARK: Relations
    
    open var creator: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.creator)
    }
    
}
}
