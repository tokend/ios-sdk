// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToAccount {
    
    case opCreateAccountDetails(_ resource: OpCreateAccountDetailsResource)
    case opCreateChangeRoleRequestDetails(_ resource: OpCreateChangeRoleRequestDetailsResource)
    case opCreateIssuanceRequestDetails(_ resource: OpCreateIssuanceRequestDetailsResource)
    case opManageBalanceDetails(_ resource: OpManageBalanceDetailsResource)
    case opPaymentDetails(_ resource: OpPaymentDetailsResource)
    case opPayoutDetails(_ resource: OpPayoutDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToAccount: OperationDetailsRelatedToAccount {
        if let resource = self as? OpCreateAccountDetailsResource {
            return .opCreateAccountDetails(resource)
        } else if let resource = self as? OpCreateChangeRoleRequestDetailsResource {
            return .opCreateChangeRoleRequestDetails(resource)
        } else if let resource = self as? OpCreateIssuanceRequestDetailsResource {
            return .opCreateIssuanceRequestDetails(resource)
        } else if let resource = self as? OpManageBalanceDetailsResource {
            return .opManageBalanceDetails(resource)
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
        
    case .opCreateAccountDetails(let resource):
        
        
    case .opCreateChangeRoleRequestDetails(let resource):
        
        
    case .opCreateIssuanceRequestDetails(let resource):
        
        
    case .opManageBalanceDetails(let resource):
        
        
    case .opPaymentDetails(let resource):
        
        
    case .opPayoutDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
