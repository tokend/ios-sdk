// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PollParticipationResource

extension Horizon {
open class PollParticipationResource: Resource {
    
    open override class var resourceType: String {
        return "poll-outcome"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case votes
    }
    
    // MARK: Relations
    
    open var votes: [Horizon.VoteResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.votes)
    }
    
}
}
