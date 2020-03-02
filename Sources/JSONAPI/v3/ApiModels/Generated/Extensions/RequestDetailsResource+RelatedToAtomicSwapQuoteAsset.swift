// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToAtomicSwapQuoteAsset {
    
    case atomicSwapAskRequestDetails(_ resource: AtomicSwapAskRequestDetailsResource)
    case atomicSwapBidRequestDetails(_ resource: AtomicSwapBidRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToAtomicSwapQuoteAsset: RequestDetailsRelatedToAtomicSwapQuoteAsset {
        if let resource = self as? AtomicSwapAskRequestDetailsResource {
            return .atomicSwapAskRequestDetails(resource)
        } else if let resource = self as? AtomicSwapBidRequestDetailsResource {
            return .atomicSwapBidRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .atomicSwapAskRequestDetails(let resource):
        
        
    case .atomicSwapBidRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
