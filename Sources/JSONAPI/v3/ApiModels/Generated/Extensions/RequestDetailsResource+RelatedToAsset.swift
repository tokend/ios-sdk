// Auto-generated code. Do not edit.

import Foundation

public enum RequestDetailsRelatedToAsset {
    
    case assetUpdateREquestDetails(_ resource: AssetUpdateREquestDetailsResource)
    case issuanceRequestDetails(_ resource: IssuanceRequestDetailsResource)
    case preIssuanceRequestDetails(_ resource: PreIssuanceRequestDetailsResource)
    case saleRequestDetails(_ resource: SaleRequestDetailsResource)
    case `self`(_ resource: RequestDetailsResource)
}

extension RequestDetailsResource {
    
    public var requestDetailsRelatedToAsset: RequestDetailsRelatedToAsset {
        if let resource = self as? AssetUpdateREquestDetailsResource {
            return .assetUpdateREquestDetails(resource)
        } else if let resource = self as? IssuanceRequestDetailsResource {
            return .issuanceRequestDetails(resource)
        } else if let resource = self as? PreIssuanceRequestDetailsResource {
            return .preIssuanceRequestDetails(resource)
        } else if let resource = self as? SaleRequestDetailsResource {
            return .saleRequestDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .assetUpdateREquestDetails(let resource):
        
        
    case .issuanceRequestDetails(let resource):
        
        
    case .preIssuanceRequestDetails(let resource):
        
        
    case .saleRequestDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
