// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageVoteOpResource

extension Horizon {
open class ManageVoteOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-vote"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case create
        case remove
        
        // relations
        case poll
        case resultProvider
        case voter
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var create: Horizon.CreateVoteOp? {
        return self.codableOptionalValue(key: CodingKeys.create)
    }
    
    open var remove: Horizon.RemoveVoteOp? {
        return self.codableOptionalValue(key: CodingKeys.remove)
    }
    
    // MARK: Relations
    
    open var poll: Horizon.PollResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.poll)
    }
    
    open var resultProvider: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.resultProvider)
    }
    
    open var voter: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.voter)
    }
    
}
}
