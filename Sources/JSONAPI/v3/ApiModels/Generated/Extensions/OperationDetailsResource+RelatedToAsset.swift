// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToAsset {
    
    case opCreateAtomicSwapAskRequestDetails(_ resource: OpCreateAtomicSwapAskRequestDetailsResource)
    case opCreateAtomicSwapBidRequestDetails(_ resource: OpCreateAtomicSwapBidRequestDetailsResource)
    case opCreateIssuanceRequestDetails(_ resource: OpCreateIssuanceRequestDetailsResource)
    case opCreatePreIssuanceRequestDetails(_ resource: OpCreatePreIssuanceRequestDetailsResource)
    case opCreateSaleRequestDetails(_ resource: OpCreateSaleRequestDetailsResource)
    case opManageAssetPairDetails(_ resource: OpManageAssetPairDetailsResource)
    case opManageBalanceDetails(_ resource: OpManageBalanceDetailsResource)
    case opManageOfferDetails(_ resource: OpManageOfferDetailsResource)
    case opPaymentDetails(_ resource: OpPaymentDetailsResource)
    case opPayoutDetails(_ resource: OpPayoutDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToAsset: OperationDetailsRelatedToAsset {
        if let resource = self as? OpCreateAtomicSwapAskRequestDetailsResource {
            return .opCreateAtomicSwapAskRequestDetails(resource)
        } else if let resource = self as? OpCreateAtomicSwapBidRequestDetailsResource {
            return .opCreateAtomicSwapBidRequestDetails(resource)
        } else if let resource = self as? OpCreateIssuanceRequestDetailsResource {
            return .opCreateIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreatePreIssuanceRequestDetailsResource {
            return .opCreatePreIssuanceRequestDetails(resource)
        } else if let resource = self as? OpCreateSaleRequestDetailsResource {
            return .opCreateSaleRequestDetails(resource)
        } else if let resource = self as? OpManageAssetPairDetailsResource {
            return .opManageAssetPairDetails(resource)
        } else if let resource = self as? OpManageBalanceDetailsResource {
            return .opManageBalanceDetails(resource)
        } else if let resource = self as? OpManageOfferDetailsResource {
            return .opManageOfferDetails(resource)
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
        
    case .opCreateAtomicSwapAskRequestDetails(let resource):
        
        
    case .opCreateAtomicSwapBidRequestDetails(let resource):
        
        
    case .opCreateIssuanceRequestDetails(let resource):
        
        
    case .opCreatePreIssuanceRequestDetails(let resource):
        
        
    case .opCreateSaleRequestDetails(let resource):
        
        
    case .opManageAssetPairDetails(let resource):
        
        
    case .opManageBalanceDetails(let resource):
        
        
    case .opManageOfferDetails(let resource):
        
        
    case .opPaymentDetails(let resource):
        
        
    case .opPayoutDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
