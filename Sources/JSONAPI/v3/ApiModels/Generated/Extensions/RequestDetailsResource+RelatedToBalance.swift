// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToBalance {
    
    case amlAlertRequestDetails(_ resource: AmlAlertRequestDetailsResource)
    case atomicSwapAskRequestDetails(_ resource: AtomicSwapAskRequestDetailsResource)
    case issuanceRequestDetails(_ resource: IssuanceRequestDetailsResource)
    case withdrawalRequestDetails(_ resource: WithdrawalRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToBalance: RequestDetailsRelatedToBalance {
        if let resource = self as? AmlAlertRequestDetailsResource {
            return .amlAlertRequestDetails(resource)
        } else if let resource = self as? AtomicSwapAskRequestDetailsResource {
            return .atomicSwapAskRequestDetails(resource)
        } else if let resource = self as? IssuanceRequestDetailsResource {
            return .issuanceRequestDetails(resource)
        } else if let resource = self as? WithdrawalRequestDetailsResource {
            return .withdrawalRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .amlAlertRequestDetails(let resource):
        
        
    case .atomicSwapAskRequestDetails(let resource):
        
        
    case .issuanceRequestDetails(let resource):
        
        
    case .withdrawalRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
