// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAsset {
    
    case createAtomicSwapAskRequestOp(_ resource: Horizon.CreateAtomicSwapAskRequestOpResource)
    case createAtomicSwapBidRequestOp(_ resource: Horizon.CreateAtomicSwapBidRequestOpResource)
    case createIssuanceRequestOp(_ resource: Horizon.CreateIssuanceRequestOpResource)
    case createSaleRequestOp(_ resource: Horizon.CreateSaleRequestOpResource)
    case manageAssetPairOp(_ resource: Horizon.ManageAssetPairOpResource)
    case manageBalanceOp(_ resource: Horizon.ManageBalanceOpResource)
    case manageOfferOp(_ resource: Horizon.ManageOfferOpResource)
    case openSwapOp(_ resource: Horizon.OpenSwapOpResource)
    case paymentOp(_ resource: Horizon.PaymentOpResource)
    case payoutOp(_ resource: Horizon.PayoutOpResource)
    case removeAssetOp(_ resource: Horizon.RemoveAssetOpResource)
    case removeAssetPairOp(_ resource: Horizon.RemoveAssetPairOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAsset: BaseOperationDetailsRelatedToAsset {
        if let resource = self as? Horizon.CreateAtomicSwapAskRequestOpResource {
            return .createAtomicSwapAskRequestOp(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapBidRequestOpResource {
            return .createAtomicSwapBidRequestOp(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestOpResource {
            return .createIssuanceRequestOp(resource)
        } else if let resource = self as? Horizon.CreateSaleRequestOpResource {
            return .createSaleRequestOp(resource)
        } else if let resource = self as? Horizon.ManageAssetPairOpResource {
            return .manageAssetPairOp(resource)
        } else if let resource = self as? Horizon.ManageBalanceOpResource {
            return .manageBalanceOp(resource)
        } else if let resource = self as? Horizon.ManageOfferOpResource {
            return .manageOfferOp(resource)
        } else if let resource = self as? Horizon.OpenSwapOpResource {
            return .openSwapOp(resource)
        } else if let resource = self as? Horizon.PaymentOpResource {
            return .paymentOp(resource)
        } else if let resource = self as? Horizon.PayoutOpResource {
            return .payoutOp(resource)
        } else if let resource = self as? Horizon.RemoveAssetOpResource {
            return .removeAssetOp(resource)
        } else if let resource = self as? Horizon.RemoveAssetPairOpResource {
            return .removeAssetPairOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAtomicSwapAskRequestOp(let resource):
        
        
    case .createAtomicSwapBidRequestOp(let resource):
        
        
    case .createIssuanceRequestOp(let resource):
        
        
    case .createSaleRequestOp(let resource):
        
        
    case .manageAssetPairOp(let resource):
        
        
    case .manageBalanceOp(let resource):
        
        
    case .manageOfferOp(let resource):
        
        
    case .openSwapOp(let resource):
        
        
    case .paymentOp(let resource):
        
        
    case .payoutOp(let resource):
        
        
    case .removeAssetOp(let resource):
        
        
    case .removeAssetPairOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
