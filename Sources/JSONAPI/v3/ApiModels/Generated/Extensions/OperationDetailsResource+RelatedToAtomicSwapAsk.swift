// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToAtomicSwapAsk {
    
    case opCancelAtomicSwapBidDetails(_ resource: OpCancelAtomicSwapBidDetailsResource)
    case opCreateAtomicSwapBidRequestDetails(_ resource: OpCreateAtomicSwapBidRequestDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToAtomicSwapAsk: OperationDetailsRelatedToAtomicSwapAsk {
        if let resource = self as? OpCancelAtomicSwapBidDetailsResource {
            return .opCancelAtomicSwapBidDetails(resource)
        } else if let resource = self as? OpCreateAtomicSwapBidRequestDetailsResource {
            return .opCreateAtomicSwapBidRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCancelAtomicSwapBidDetails(let resource):
        
        
    case .opCreateAtomicSwapBidRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
