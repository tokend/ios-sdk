// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToBalance {
    
    case createAmlAlertRequestOp(_ resource: Horizon.CreateAmlAlertRequestOpResource)
    case createAtomicSwapAskRequestOp(_ resource: Horizon.CreateAtomicSwapAskRequestOpResource)
    case createCloseDeferredPaymentRequestOp(_ resource: Horizon.CreateCloseDeferredPaymentRequestOpResource)
    case createDeferredPaymentCreationRequestOp(_ resource: Horizon.CreateDeferredPaymentCreationRequestOpResource)
    case createIssuanceRequestOp(_ resource: Horizon.CreateIssuanceRequestOpResource)
    case createPaymentRequestOp(_ resource: Horizon.CreatePaymentRequestOpResource)
    case createRedemptionRequestOp(_ resource: Horizon.CreateRedemptionRequestOpResource)
    case createWithdrawRequestOp(_ resource: Horizon.CreateWithdrawRequestOpResource)
    case lpManageLiquidityOp(_ resource: Horizon.LpManageLiquidityOpResource)
    case lpSwapOp(_ resource: Horizon.LpSwapOpResource)
    case openSwapOp(_ resource: Horizon.OpenSwapOpResource)
    case paymentOp(_ resource: Horizon.PaymentOpResource)
    case payoutOp(_ resource: Horizon.PayoutOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToBalance: BaseOperationDetailsRelatedToBalance {
        if let resource = self as? Horizon.CreateAmlAlertRequestOpResource {
            return .createAmlAlertRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestOpResource {
            return .createAtomicSwapAskRequestOp(resource)
        } else if let resource = self as? Horizon.CreateCloseDeferredPaymentRequestOpResource {
            return .createCloseDeferredPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDeferredPaymentCreationRequestOpResource {
            return .createDeferredPaymentCreationRequestOp(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestOpResource {
            return .createIssuanceRequestOp(resource)
        } else if let resource = self as? Horizon.CreatePaymentRequestOpResource {
            return .createPaymentRequestOp(resource)
        } else if let resource = self as? Horizon.CreateRedemptionRequestOpResource {
            return .createRedemptionRequestOp(resource)
        } else if let resource = self as? Horizon.CreateWithdrawRequestOpResource {
            return .createWithdrawRequestOp(resource)
        } else if let resource = self as? Horizon.LpManageLiquidityOpResource {
            return .lpManageLiquidityOp(resource)
        } else if let resource = self as? Horizon.LpSwapOpResource {
            return .lpSwapOp(resource)
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
        
    case .createAmlAlertRequestOp(let resource):
        
        
    case .createAtomicSwapAskRequestOp(let resource):
        
        
    case .createCloseDeferredPaymentRequestOp(let resource):
        
        
    case .createDeferredPaymentCreationRequestOp(let resource):
        
        
    case .createIssuanceRequestOp(let resource):
        
        
    case .createPaymentRequestOp(let resource):
        
        
    case .createRedemptionRequestOp(let resource):
        
        
    case .createWithdrawRequestOp(let resource):
        
        
    case .lpManageLiquidityOp(let resource):
        
        
    case .lpSwapOp(let resource):
        
        
    case .openSwapOp(let resource):
        
        
    case .paymentOp(let resource):
        
        
    case .payoutOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
