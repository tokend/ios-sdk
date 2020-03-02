// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - VoteResource

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
    
    open var voteData: VoteData? {
        return self.codableOptionalValue(key: CodingKeys.voteData)
    }
    
    // MARK: Relations
    
    open var poll: PollResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.poll)
    }
    
    open var voter: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.voter)
    }
    
}
