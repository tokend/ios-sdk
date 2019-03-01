// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToBalance {
    
    case aSwapBidRequestDetails(_ resource: ASwapBidRequestDetailsResource)
    case amlAlertRequestDetails(_ resource: AmlAlertRequestDetailsResource)
    case issuanceRequestDetails(_ resource: IssuanceRequestDetailsResource)
    case withdrawalRequestDetails(_ resource: WithdrawalRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToBalance: RequestDetailsRelatedToBalance {
        if let resource = self as? ASwapBidRequestDetailsResource {
            return .aSwapBidRequestDetails(resource)
        } else if let resource = self as? AmlAlertRequestDetailsResource {
            return .amlAlertRequestDetails(resource)
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
        
    case .aSwapBidRequestDetails(let resource):
        
        
    case .amlAlertRequestDetails(let resource):
        
        
    case .issuanceRequestDetails(let resource):
        
        
    case .withdrawalRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
