// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - VoteResource

extension Horizon {
open class VoteResource: Resource {
    
    open override class var resourceType: String {
        return "votes"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case voteData
        
        // relations
        case poll
        case voter
    }
    
    // MARK: Attributes
    
    open var voteData: Horizon.VoteData? {
        return self.codableOptionalValue(key: CodingKeys.voteData)
    }
    
    // MARK: Relations
    
    open var poll: Horizon.PollResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.poll)
    }
    
    open var voter: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.voter)
    }
    
}
}
