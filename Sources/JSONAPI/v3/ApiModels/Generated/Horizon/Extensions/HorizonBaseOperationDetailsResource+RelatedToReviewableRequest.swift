// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToReviewableRequest {
    
    case cancelCloseDeferredPaymentRequestOp(_ resource: Horizon.CancelCloseDeferredPaymentRequestOpResource)
    case cancelDataCreationRequestOp(_ resource: Horizon.CancelDataCreationRequestOpResource)
    case cancelDataRemoveRequestOp(_ resource: Horizon.CancelDataRemoveRequestOpResource)
    case cancelDataUpdateRequestOp(_ resource: Horizon.CancelDataUpdateRequestOpResource)
    case cancelDeferredPaymentCreationRequestOp(_ resource: Horizon.CancelDeferredPaymentCreationRequestOpResource)
    case createAmlAlertRequestOp(_ resource: Horizon.CreateAmlAlertRequestOpResource)
    case createAtomicSwapAskRequestOp(_ resource: Horizon.CreateAtomicSwapAskRequestOpResource)
    case createAtomicSwapBidRequestOp(_ resource: Horizon.CreateAtomicSwapBidRequestOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
    case createCloseDeferredPaymentRequestOp(_ resource: Horizon.CreateCloseDeferredPaymentRequestOpResource)
    case createDataCreationRequestOp(_ resource: Horizon.CreateDataCreationRequestOpResource)
    case createDataRemoveRequestOp(_ resource: Horizon.CreateDataRemoveRequestOpResource)
    case createDataUpdateRequestOp(_ resource: Horizon.CreateDataUpdateRequestOpResource)
    case createDeferredPaymentCreationRequestOp(_ resource: Horizon.CreateDeferredPaymentCreationRequestOpResource)
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
        if let resource = self as? Horizon.CancelCloseDeferredPaymentRequestOpResource {
            return .cancelCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataCreationRequestOpResource {
            return .cancelDataCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataRemoveRequestOpResource {
            return .cancelDataRemoveRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDataUpdateRequestOpResource {
            return .cancelDataUpdateRequestOp(resource)
        } else if let resource = self as? Horizon.CancelDeferredPaymentCreationRequestOpResource {
            return .cancelDeferredPaymentCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAmlAlertRequestOpResource {
            return .createAmlAlertRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestOpResource {
            return .createAtomicSwapAskRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestOpResource {
            return .createAtomicSwapBidRequestOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
        } else if let resource = self as? Horizon.CreateCloseDeferredPaymentRequestOpResource {
            return .createCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataCreationRequestOpResource {
            return .createDataCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataRemoveRequestOpResource {
            return .createDataRemoveRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataUpdateRequestOpResource {
            return .createDataUpdateRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDeferredPaymentCreationRequestOpResource {
            return .createDeferredPaymentCreationRequestOp(resource)
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
        
    case .cancelCloseDeferredPaymentRequestOp(let resource):
        
        
    case .cancelDataCreationRequestOp(let resource):
        
        
    case .cancelDataRemoveRequestOp(let resource):
        
        
    case .cancelDataUpdateRequestOp(let resource):
        
        
    case .cancelDeferredPaymentCreationRequestOp(let resource):
        
        
    case .createAmlAlertRequestOp(let resource):
        
        
    case .createAtomicSwapAskRequestOp(let resource):
        
        
    case .createAtomicSwapBidRequestOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
    case .createCloseDeferredPaymentRequestOp(let resource):
        
        
    case .createDataCreationRequestOp(let resource):
        
        
    case .createDataRemoveRequestOp(let resource):
        
        
    case .createDataUpdateRequestOp(let resource):
        
        
    case .createDeferredPaymentCreationRequestOp(let resource):
        
        
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
