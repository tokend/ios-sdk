// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToData {
    
    case createDataRemoveRequestOp(_ resource: Horizon.CreateDataRemoveRequestOpResource)
    case createDataUpdateRequestOp(_ resource: Horizon.CreateDataUpdateRequestOpResource)
    case removeDataOp(_ resource: Horizon.RemoveDataOpResource)
    case updateDataOp(_ resource: Horizon.UpdateDataOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToData: BaseOperationDetailsRelatedToData {
        if let resource = self as? Horizon.CreateDataRemoveRequestOpResource {
            return .createDataRemoveRequestOp(resource)
        } else if let resource = self as? Horizon.CreateDataUpdateRequestOpResource {
            return .createDataUpdateRequestOp(resource)
        } else if let resource = self as? Horizon.RemoveDataOpResource {
            return .removeDataOp(resource)
        } else if let resource = self as? Horizon.UpdateDataOpResource {
            return .updateDataOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createDataRemoveRequestOp(let resource):
        
        
    case .createDataUpdateRequestOp(let resource):
        
        
    case .removeDataOp(let resource):
        
        
    case .updateDataOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
