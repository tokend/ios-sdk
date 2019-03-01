// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToBalance {
    
    case opCreateAMLAlertRequestDetails(_ resource: OpCreateAMLAlertRequestDetailsResource)
    case opCreateAtomicSwapBidRequestDetails(_ resource: OpCreateAtomicSwapBidRequestDetailsResource)
    case opCreateIssuanceRequestDetails(_ resource: OpCreateIssuanceRequestDetailsResource)
    case opCreateWithdrawRequestDetails(_ resource: OpCreateWithdrawRequestDetailsResource)
    case opPaymentDetails(_ resource: OpPaymentDetailsResource)
    case opPayoutDetails(_ resource: OpPayoutDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToBalance: OperationDetailsRelatedToBalance {
        if let resource = self as? OpCreateAMLAlertRequestDetailsResource {
            return .opCreateAMLAlertRequestDetails(resource)
        } else if let resource = self as? OpCreateAtomicSwapBidRequestDetailsResource {
            return .opCreateAtomicSwapBidRequestDetails(resource)
        } else if let resource = self as? OpCreateIssuanceRequestDetailsResource {
            return .opCreateIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateWithdrawRequestDetailsResource {
            return .opCreateWithdrawRequestDetails(resource)
        } else if let resource = self as? OpPaymentDetailsResource {
            return .opPaymentDetails(resource)
        } else if let resource = self as? OpPayoutDetailsResource {
            return .opPayoutDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateAMLAlertRequestDetails(let resource):
        
        
    case .opCreateAtomicSwapBidRequestDetails(let resource):
        
        
    case .opCreateIssuanceRequestDetails(let resource):
        
        
    case .opCreateWithdrawRequestDetails(let resource):
        
        
    case .opPaymentDetails(let resource):
        
        
    case .opPayoutDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
