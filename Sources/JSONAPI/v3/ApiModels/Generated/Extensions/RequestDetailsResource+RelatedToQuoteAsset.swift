// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToQuoteAsset {
    
    case atomicSwapAskRequestDetails(_ resource: AtomicSwapAskRequestDetailsResource)
    case atomicSwapBidRequestDetails(_ resource: AtomicSwapBidRequestDetailsResource)
    case saleRequestDetails(_ resource: SaleRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToQuoteAsset: RequestDetailsRelatedToQuoteAsset {
        if let resource = self as? AtomicSwapAskRequestDetailsResource {
            return .atomicSwapAskRequestDetails(resource)
        } else if let resource = self as? AtomicSwapBidRequestDetailsResource {
            return .atomicSwapBidRequestDetails(resource)
        } else if let resource = self as? SaleRequestDetailsResource {
            return .saleRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .atomicSwapAskRequestDetails(let resource):
        
        
    case .atomicSwapBidRequestDetails(let resource):
        
        
    case .saleRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
