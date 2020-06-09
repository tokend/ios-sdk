// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAtomicSwapAsk {
    
    case cancelAtomicSwapAskOp(_ resource: Horizon.CancelAtomicSwapAskOpResource)
    case createAtomicSwapBidRequestOp(_ resource: Horizon.CreateAtomicSwapBidRequestOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAtomicSwapAsk: BaseOperationDetailsRelatedToAtomicSwapAsk {
        if let resource = self as? Horizon.CancelAtomicSwapAskOpResource {
            return .cancelAtomicSwapAskOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestOpResource {
            return .createAtomicSwapBidRequestOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .cancelAtomicSwapAskOp(let resource):
        
        
    case .createAtomicSwapBidRequestOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
