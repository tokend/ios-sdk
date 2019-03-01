// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToQuoteAsset {
    
    case aSwapBidRequestDetails(_ resource: ASwapBidRequestDetailsResource)
    case atomicSwapRequestDetails(_ resource: AtomicSwapRequestDetailsResource)
    case saleRequestDetails(_ resource: SaleRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToQuoteAsset: RequestDetailsRelatedToQuoteAsset {
        if let resource = self as? ASwapBidRequestDetailsResource {
            return .aSwapBidRequestDetails(resource)
        } else if let resource = self as? AtomicSwapRequestDetailsResource {
            return .atomicSwapRequestDetails(resource)
        } else if let resource = self as? SaleRequestDetailsResource {
            return .saleRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .aSwapBidRequestDetails(let resource):
        
        
    case .atomicSwapRequestDetails(let resource):
        
        
    case .saleRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
