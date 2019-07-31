// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToReviewableRequest {
    
    case opCreateAtomicSwapAskRequestDetails(_ resource: OpCreateAtomicSwapAskRequestDetailsResource)
    case opCreateAtomicSwapBidRequestDetails(_ resource: OpCreateAtomicSwapBidRequestDetailsResource)
    case opCreateChangeRoleRequestDetails(_ resource: OpCreateChangeRoleRequestDetailsResource)
    case opCreateIssuanceRequestDetails(_ resource: OpCreateIssuanceRequestDetailsResource)
    case opCreateManageLimitsRequestDetails(_ resource: OpCreateManageLimitsRequestDetailsResource)
    case opCreatePreIssuanceRequestDetails(_ resource: OpCreatePreIssuanceRequestDetailsResource)
    case opCreateSaleRequestDetails(_ resource: OpCreateSaleRequestDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToReviewableRequest: OperationDetailsRelatedToReviewableRequest {
        if let resource = self as? OpCreateAtomicSwapAskRequestDetailsResource {
            return .opCreateAtomicSwapAskRequestDetails(resource)
        } else if let resource = self as? OpCreateAtomicSwapBidRequestDetailsResource {
            return .opCreateAtomicSwapBidRequestDetails(resource)
        } else if let resource = self as? OpCreateChangeRoleRequestDetailsResource {
            return .opCreateChangeRoleRequestDetails(resource)
        } else if let resource = self as? OpCreateIssuanceRequestDetailsResource {
            return .opCreateIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateManageLimitsRequestDetailsResource {
            return .opCreateManageLimitsRequestDetails(resource)
        } else if let resource = self as? OpCreatePreIssuanceRequestDetailsResource {
            return .opCreatePreIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateSaleRequestDetailsResource {
            return .opCreateSaleRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateAtomicSwapAskRequestDetails(let resource):
        
        
    case .opCreateAtomicSwapBidRequestDetails(let resource):
        
        
    case .opCreateChangeRoleRequestDetails(let resource):
        
        
    case .opCreateIssuanceRequestDetails(let resource):
        
        
    case .opCreateManageLimitsRequestDetails(let resource):
        
        
    case .opCreatePreIssuanceRequestDetails(let resource):
        
        
    case .opCreateSaleRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
