// Auto-generated code. Do not edit.

import Foundation

public enum BaseReviewableRequestDetailsRelatedToBalance {
    
    case createAmlAlertRequest(_ resource: Horizon.CreateAmlAlertRequestResource)
    case createAtomicSwapAskRequest(_ resource: Horizon.CreateAtomicSwapAskRequestResource)
    case createIssuanceRequest(_ resource: Horizon.CreateIssuanceRequestResource)
    case createPaymentRequest(_ resource: Horizon.CreatePaymentRequestResource)
    case createWithdrawRequest(_ resource: Horizon.CreateWithdrawRequestResource)
    case redemptionRequest(_ resource: Horizon.RedemptionRequestResource)
    case `self`(_ resource: Horizon.BaseReviewableRequestDetailsResource)
}

extension Horizon.BaseReviewableRequestDetailsResource {
    
    public var baseReviewableRequestDetailsRelatedToBalance: BaseReviewableRequestDetailsRelatedToBalance {
        if let resource = self as? Horizon.CreateAmlAlertRequestResource {
            return .createAmlAlertRequest(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestResource {
            return .createAtomicSwapAskRequest(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestResource {
            return .createIssuanceRequest(resource)
        } else if let resource = self as? Horizon.CreatePaymentRequestResource {
            return .createPaymentRequest(resource)
        } else if let resource = self as? Horizon.CreateWithdrawRequestResource {
            return .createWithdrawRequest(resource)
        } else if let resource = self as? Horizon.RedemptionRequestResource {
            return .redemptionRequest(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAmlAlertRequest(let resource):
        
        
    case .createAtomicSwapAskRequest(let resource):
        
        
    case .createIssuanceRequest(let resource):
        
        
    case .createPaymentRequest(let resource):
        
        
    case .createWithdrawRequest(let resource):
        
        
    case .redemptionRequest(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
