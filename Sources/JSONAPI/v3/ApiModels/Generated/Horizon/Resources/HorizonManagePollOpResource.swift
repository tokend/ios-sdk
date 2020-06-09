// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManagePollOpResource

extension Horizon {
open class ManagePollOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-poll"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case close
        case pollId
        case updateEndTime
        
        // relations
        case poll
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var close: Horizon.ClosePollOp? {
        return self.codableOptionalValue(key: CodingKeys.close)
    }
    
    open var pollId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.pollId) ?? 0
    }
    
    open var updateEndTime: Horizon.UpdatePollEndTimeOp? {
        return self.codableOptionalValue(key: CodingKeys.updateEndTime)
    }
    
    // MARK: Relations
    
    open var poll: Horizon.PollResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.poll)
    }
    
}
}
