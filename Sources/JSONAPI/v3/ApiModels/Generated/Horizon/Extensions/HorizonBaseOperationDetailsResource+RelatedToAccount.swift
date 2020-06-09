// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAccount {
    
    case createAccountOp(_ resource: Horizon.CreateAccountOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
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
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAccount: BaseOperationDetailsRelatedToAccount {
        if let resource = self as? Horizon.CreateAccountOpResource {
            return .createAccountOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
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
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAccountOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
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
        
        
    case .`self`(let resource):
        
    }
*/
