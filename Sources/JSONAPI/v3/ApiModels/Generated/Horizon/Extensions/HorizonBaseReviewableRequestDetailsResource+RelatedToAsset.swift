// Auto-generated code. Do not edit.

import Foundation

public enum BaseReviewableRequestDetailsRelatedToAsset {
    
    case createAssetRequest(_ resource: Horizon.CreateAssetRequestResource)
    case createAtomicSwapAskRequest(_ resource: Horizon.CreateAtomicSwapAskRequestResource)
    case createIssuanceRequest(_ resource: Horizon.CreateIssuanceRequestResource)
    case createPreIssuanceRequest(_ resource: Horizon.CreatePreIssuanceRequestResource)
    case createSaleRequest(_ resource: Horizon.CreateSaleRequestResource)
    case createWithdrawRequest(_ resource: Horizon.CreateWithdrawRequestResource)
    case updateAssetRequest(_ resource: Horizon.UpdateAssetRequestResource)
    case `self`(_ resource: Horizon.BaseReviewableRequestDetailsResource)
}

extension Horizon.BaseReviewableRequestDetailsResource {
    
    public var baseReviewableRequestDetailsRelatedToAsset: BaseReviewableRequestDetailsRelatedToAsset {
        if let resource = self as? Horizon.CreateAssetRequestResource {
            return .createAssetRequest(resource)
        } else if let resource = self as? Horizon.CreateAtomicSwapAskRequestResource {
            return .createAtomicSwapAskRequest(resource)
        } else if let resource = self as? Horizon.CreateIssuanceRequestResource {
            return .createIssuanceRequest(resource)
        } else if let resource = self as? Horizon.CreatePreIssuanceRequestResource {
            return .createPreIssuanceRequest(resource)
        } else if let resource = self as? Horizon.CreateSaleRequestResource {
            return .createSaleRequest(resource)
        } else if let resource = self as? Horizon.CreateWithdrawRequestResource {
            return .createWithdrawRequest(resource)
        } else if let resource = self as? Horizon.UpdateAssetRequestResource {
            return .updateAssetRequest(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAssetRequest(let resource):
        
        
    case .createAtomicSwapAskRequest(let resource):
        
        
    case .createIssuanceRequest(let resource):
        
        
    case .createPreIssuanceRequest(let resource):
        
        
    case .createSaleRequest(let resource):
        
        
    case .createWithdrawRequest(let resource):
        
        
    case .updateAssetRequest(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
