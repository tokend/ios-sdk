// Auto-generated code. Do not edit.

import Foundation

public enum BaseReviewableRequestDetailsRelatedToData {
    
    case dataRemoveRequest(_ resource: Horizon.DataRemoveRequestResource)
    case dataUpdateRequest(_ resource: Horizon.DataUpdateRequestResource)
    case `self`(_ resource: Horizon.BaseReviewableRequestDetailsResource)
}

extension Horizon.BaseReviewableRequestDetailsResource {
    
    public var baseReviewableRequestDetailsRelatedToData: BaseReviewableRequestDetailsRelatedToData {
        if let resource = self as? Horizon.DataRemoveRequestResource {
            return .dataRemoveRequest(resource)
        } else if let resource = self as? Horizon.DataUpdateRequestResource {
            return .dataUpdateRequest(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .dataRemoveRequest(let resource):
        
        
    case .dataUpdateRequest(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
