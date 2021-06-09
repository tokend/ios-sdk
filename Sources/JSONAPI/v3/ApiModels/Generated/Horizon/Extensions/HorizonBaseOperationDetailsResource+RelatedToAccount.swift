// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAccount {
    
    case createAccountOp(_ resource: Horizon.CreateAccountOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
    case createCloseDeferredPaymentRequestOp(_ resource: Horizon.CreateCloseDeferredPaymentRequestOpResource)
    case createDataCreationRequestOp(_ resource: Horizon.CreateDataCreationRequestOpResource)
    case createDataOp(_ resource: Horizon.CreateDataOpResource)
    case createDataRemoveRequestOp(_ resource: Horizon.CreateDataRemoveRequestOpResource)
    case createDataUpdateRequestOp(_ resource: Horizon.CreateDataUpdateRequestOpResource)
    case createDeferredPaymentCreationRequestOp(_ resource: Horizon.CreateDeferredPaymentCreationRequestOpResource)
    case createIssuanceRequestOp(_ resource: Horizon.CreateIssuanceRequestOpResource)
    case createKYCRecoveryRequestOp(_ resource: Horizon.CreateKYCRecoveryRequestOpResource)
    case createPaymentRequestOp(_ resource: Horizon.CreatePaymentRequestOpResource)
    case createRedemptionRequestOp(_ resource: Horizon.CreateRedemptionRequestOpResource)
    case initiateKYCRecoveryOp(_ resource: Horizon.InitiateKYCRecoveryOpResource)
    case manageBalanceOp(_ resource: Horizon.ManageBalanceOpResource)
    case manageCreatePollRequestOp(_ resource: Horizon.ManageCreatePollRequestOpResource)
    case manageVoteOp(_ resource: Horizon.ManageVoteOpResource)
    case openSwapOp(_ resource: Horizon.OpenSwapOpResource)
    case paymentOp(_ resource: Horizon.PaymentOpResource)
    case payoutOp(_ resource: Horizon.PayoutOpResource)
    case removeDataOp(_ resource: Horizon.RemoveDataOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAccount: BaseOperationDetailsRelatedToAccount {
        if let resource = self as? Horizon.CreateAccountOpResource {
            return .createAccountOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
        } else if let resource = self as? Horizon.CreateCloseDeferredPaymentRequestOpResource {
            return .createCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataCreationRequestOpResource {
            return .createDataCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataOpResource {
            return .createDataOp(resource)
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
        } else if let resource = self as? Horizon.CreatePaymentRequestOpResource {
            return .createPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateRedemptionRequestOpResource {
            return .createRedemptionRequestOp(resource)
        } else if let resource = self as? Horizon.InitiateKYCRecoveryOpResource {
            return .initiateKYCRecoveryOp(resource)
        } else if let resource = self as? Horizon.ManageBalanceOpResource {
            return .manageBalanceOp(resource)
        } else if let resource = self as? Horizon.ManageCreatePollRequestOpResource {
            return .manageCreatePollRequestOp(resource)
        } else if let resource = self as? Horizon.ManageVoteOpResource {
            return .manageVoteOp(resource)
        } else if let resource = self as? Horizon.OpenSwapOpResource {
            return .openSwapOp(resource)
        } else if let resource = self as? Horizon.PaymentOpResource {
            return .paymentOp(resource)
        } else if let resource = self as? Horizon.PayoutOpResource {
            return .payoutOp(resource)
        } else if let resource = self as? Horizon.RemoveDataOpResource {
            return .removeDataOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAccountOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
    case .createCloseDeferredPaymentRequestOp(let resource):
        
        
    case .createDataCreationRequestOp(let resource):
        
        
    case .createDataOp(let resource):
        
        
    case .createDataRemoveRequestOp(let resource):
        
        
    case .createDataUpdateRequestOp(let resource):
        
        
    case .createDeferredPaymentCreationRequestOp(let resource):
        
        
    case .createIssuanceRequestOp(let resource):
        
        
    case .createKYCRecoveryRequestOp(let resource):
        
        
    case .createPaymentRequestOp(let resource):
        
        
    case .createRedemptionRequestOp(let resource):
        
        
    case .initiateKYCRecoveryOp(let resource):
        
        
    case .manageBalanceOp(let resource):
        
        
    case .manageCreatePollRequestOp(let resource):
        
        
    case .manageVoteOp(let resource):
        
        
    case .openSwapOp(let resource):
        
        
    case .paymentOp(let resource):
        
        
    case .payoutOp(let resource):
        
        
    case .removeDataOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
