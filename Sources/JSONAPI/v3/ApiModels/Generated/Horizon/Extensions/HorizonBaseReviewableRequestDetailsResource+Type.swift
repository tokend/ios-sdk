// Auto-generated code. Do not edit.

import Foundation

public enum BaseReviewableRequestDetailsType {
    
    case changeRoleRequest(_ resource: Horizon.ChangeRoleRequestResource)
    case createAmlAlertRequest(_ resource: Horizon.CreateAmlAlertRequestResource)
    case createAssetRequest(_ resource: Horizon.CreateAssetRequestResource)
    case createAtomicSwapAskRequest(_ resource: Horizon.CreateAtomicSwapAskRequestResource)
    case createAtomicSwapBidRequest(_ resource: Horizon.CreateAtomicSwapBidRequestResource)
    case createIssuanceRequest(_ resource: Horizon.CreateIssuanceRequestResource)
    case createPaymentRequest(_ resource: Horizon.CreatePaymentRequestResource)
    case createPollRequest(_ resource: Horizon.CreatePollRequestResource)
    case createPreIssuanceRequest(_ resource: Horizon.CreatePreIssuanceRequestResource)
    case createSaleRequest(_ resource: Horizon.CreateSaleRequestResource)
    case createWithdrawRequest(_ resource: Horizon.CreateWithdrawRequestResource)
    case kYCRecoveryRequest(_ resource: Horizon.KYCRecoveryRequestResource)
    case manageOfferRequest(_ resource: Horizon.ManageOfferRequestResource)
    case redemptionRequest(_ resource: Horizon.RedemptionRequestResource)
    case updateAssetRequest(_ resource: Horizon.UpdateAssetRequestResource)
    case updateLimitsRequest(_ resource: Horizon.UpdateLimitsRequestResource)
    case updateSaleDetailsRequest(_ resource: Horizon.UpdateSaleDetailsRequestResource)
    case `self`(_ resource: Horizon.BaseReviewableRequestDetailsResource)
}

extension Horizon.BaseReviewableRequestDetailsResource {
    
    public var baseReviewableRequestDetailsType: BaseReviewableRequestDetailsType {
        if let resource = self as? Horizon.ChangeRoleRequestResource {
            return .changeRoleRequest(resource)
        } else if let resource = self as? Horizon.CreateAmlAlertRequestResource {
            return .createAmlAlertRequest(resource)
        } else if let resource = self as? Horizon.CreateAssetRequestResource {
            return .createAssetRequest(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestResource {
            return .createAtomicSwapAskRequest(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestResource {
            return .createAtomicSwapBidRequest(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestResource {
            return .createIssuanceRequest(resource)
        } else if let resource = self as? Horizon.CreatePaymentRequestResource {
            return .createPaymentRequest(resource)
        } else if let resource = self as? Horizon.CreatePollRequestResource {
            return .createPollRequest(resource)
        } else if let resource = self as? Horizon.CreatePreIssuanceRequestResource {
            return .createPreIssuanceRequest(resource)
        } else if let resource = self as? Horizon.CreateSaleRequestResource {
            return .createSaleRequest(resource)
        } else if let resource = self as? Horizon.CreateWithdrawRequestResource {
            return .createWithdrawRequest(resource)
        } else if let resource = self as? Horizon.KYCRecoveryRequestResource {
            return .kYCRecoveryRequest(resource)
        } else if let resource = self as? Horizon.ManageOfferRequestResource {
            return .manageOfferRequest(resource)
        } else if let resource = self as? Horizon.RedemptionRequestResource {
            return .redemptionRequest(resource)
        } else if let resource = self as? Horizon.UpdateAssetRequestResource {
            return .updateAssetRequest(resource)
        } else if let resource = self as? Horizon.UpdateLimitsRequestResource {
            return .updateLimitsRequest(resource)
        } else if let resource = self as? Horizon.UpdateSaleDetailsRequestResource {
            return .updateSaleDetailsRequest(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .changeRoleRequest(let resource):
        
        
    case .createAmlAlertRequest(let resource):
        
        
    case .createAssetRequest(let resource):
        
        
    case .createAtomicSwapAskRequest(let resource):
        
        
    case .createAtomicSwapBidRequest(let resource):
        
        
    case .createIssuanceRequest(let resource):
        
        
    case .createPaymentRequest(let resource):
        
        
    case .createPollRequest(let resource):
        
        
    case .createPreIssuanceRequest(let resource):
        
        
    case .createSaleRequest(let resource):
        
        
    case .createWithdrawRequest(let resource):
        
        
    case .kYCRecoveryRequest(let resource):
        
        
    case .manageOfferRequest(let resource):
        
        
    case .redemptionRequest(let resource):
        
        
    case .updateAssetRequest(let resource):
        
        
    case .updateLimitsRequest(let resource):
        
        
    case .updateSaleDetailsRequest(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
