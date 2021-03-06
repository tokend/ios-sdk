// Auto-generated code. Do not edit.

import Foundation

public enum BaseReviewableRequestDetailsRelatedToAccount {
    
    case changeRoleRequest(_ resource: Horizon.ChangeRoleRequestResource)
    case closeDeferredPaymentRequest(_ resource: Horizon.CloseDeferredPaymentRequestResource)
    case createDeferredPaymentRequest(_ resource: Horizon.CreateDeferredPaymentRequestResource)
    case createPollRequest(_ resource: Horizon.CreatePollRequestResource)
    case dataCreationRequest(_ resource: Horizon.DataCreationRequestResource)
    case kYCRecoveryRequest(_ resource: Horizon.KYCRecoveryRequestResource)
    case redemptionRequest(_ resource: Horizon.RedemptionRequestResource)
    case `self`(_ resource: Horizon.BaseReviewableRequestDetailsResource)
}

extension Horizon.BaseReviewableRequestDetailsResource {
    
    public var baseReviewableRequestDetailsRelatedToAccount: BaseReviewableRequestDetailsRelatedToAccount {
        if let resource = self as? Horizon.ChangeRoleRequestResource {
            return .changeRoleRequest(resource)
        } else if let resource = self as? Horizon.CloseDeferredPaymentRequestResource {
            return .closeDeferredPaymentRequest(resource)
        } else if let resource = self as? Horizon.CreateDeferredPaymentRequestResource {
            return .createDeferredPaymentRequest(resource)
        } else if let resource = self as? Horizon.CreatePollRequestResource {
            return .createPollRequest(resource)
        } else if let resource = self as? Horizon.DataCreationRequestResource {
            return .dataCreationRequest(resource)
        } else if let resource = self as? Horizon.KYCRecoveryRequestResource {
            return .kYCRecoveryRequest(resource)
        } else if let resource = self as? Horizon.RedemptionRequestResource {
            return .redemptionRequest(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .changeRoleRequest(let resource):
        
        
    case .closeDeferredPaymentRequest(let resource):
        
        
    case .createDeferredPaymentRequest(let resource):
        
        
    case .createPollRequest(let resource):
        
        
    case .dataCreationRequest(let resource):
        
        
    case .kYCRecoveryRequest(let resource):
        
        
    case .redemptionRequest(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
