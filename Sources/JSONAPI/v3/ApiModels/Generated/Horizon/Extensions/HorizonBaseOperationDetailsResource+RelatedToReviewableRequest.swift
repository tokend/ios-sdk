// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToReviewableRequest {
    
    case createAtomicSwapAskRequestOp(_ resource: Horizon.CreateAtomicSwapAskRequestOpResource)
    case createAtomicSwapBidRequestOp(_ resource: Horizon.CreateAtomicSwapBidRequestOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
    case createIssuanceRequestOp(_ resource: Horizon.CreateIssuanceRequestOpResource)
    case createKYCRecoveryRequestOp(_ resource: Horizon.CreateKYCRecoveryRequestOpResource)
    case createManageLimitsRequestOp(_ resource: Horizon.CreateManageLimitsRequestOpResource)
    case createManageOfferRequestOp(_ resource: Horizon.CreateManageOfferRequestOpResource)
    case createPaymentRequestOp(_ resource: Horizon.CreatePaymentRequestOpResource)
    case createRedemptionRequestOp(_ resource: Horizon.CreateRedemptionRequestOpResource)
    case createSaleRequestOp(_ resource: Horizon.CreateSaleRequestOpResource)
    case manageAssetOp(_ resource: Horizon.ManageAssetOpResource)
    case manageCreatePollRequestOp(_ resource: Horizon.ManageCreatePollRequestOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToReviewableRequest: BaseOperationDetailsRelatedToReviewableRequest {
        if let resource = self as? Horizon.CreateAtomicSwapAskRequestOpResource {
            return .createAtomicSwapAskRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestOpResource {
            return .createAtomicSwapBidRequestOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestOpResource {
            return .createIssuanceRequestOp(resource)
        } else if let resource = self as? Horizon.CreateKYCRecoveryRequestOpResource {
            return .createKYCRecoveryRequestOp(resource)
        } else if let resource = self as? Horizon.CreateManageLimitsRequestOpResource {
            return .createManageLimitsRequestOp(resource)
        } else if let resource = self as? Horizon.CreateManageOfferRequestOpResource {
            return .createManageOfferRequestOp(resource)
        } else if let resource = self as? Horizon.CreatePaymentRequestOpResource {
            return .createPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateRedemptionRequestOpResource {
            return .createRedemptionRequestOp(resource)
        } else if let resource = self as? Horizon.CreateSaleRequestOpResource {
            return .createSaleRequestOp(resource)
        } else if let resource = self as? Horizon.ManageAssetOpResource {
            return .manageAssetOp(resource)
        } else if let resource = self as? Horizon.ManageCreatePollRequestOpResource {
            return .manageCreatePollRequestOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAtomicSwapAskRequestOp(let resource):
        
        
    case .createAtomicSwapBidRequestOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
    case .createIssuanceRequestOp(let resource):
        
        
    case .createKYCRecoveryRequestOp(let resource):
        
        
    case .createManageLimitsRequestOp(let resource):
        
        
    case .createManageOfferRequestOp(let resource):
        
        
    case .createPaymentRequestOp(let resource):
        
        
    case .createRedemptionRequestOp(let resource):
        
        
    case .createSaleRequestOp(let resource):
        
        
    case .manageAssetOp(let resource):
        
        
    case .manageCreatePollRequestOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
