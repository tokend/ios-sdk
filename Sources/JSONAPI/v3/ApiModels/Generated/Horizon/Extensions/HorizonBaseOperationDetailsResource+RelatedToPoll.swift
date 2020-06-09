// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToPoll {
    
    case managePollOp(_ resource: Horizon.ManagePollOpResource)
    case manageVoteOp(_ resource: Horizon.ManageVoteOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToPoll: BaseOperationDetailsRelatedToPoll {
        if let resource = self as? Horizon.ManagePollOpResource {
            return .managePollOp(resource)
        } else if let resource = self as? Horizon.ManageVoteOpResource {
            return .manageVoteOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .managePollOp(let resource):
        
        
    case .manageVoteOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
