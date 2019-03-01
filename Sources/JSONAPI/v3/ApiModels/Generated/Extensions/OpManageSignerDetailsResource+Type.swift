// Auto-generated code. Do not edit.

import Foundation

public enum OpManageSignerDetailsType {
    
    case opCreateSignerDetails(_ resource: OpCreateSignerDetailsResource)
    case opRemoveSignerDetails(_ resource: OpRemoveSignerDetailsResource)
    case opUpdateSignerDetails(_ resource: OpUpdateSignerDetailsResource)
    case `self`(_ resource: OpManageSignerDetailsResource)
}

extension OpManageSignerDetailsResource {
    
    public var opManageSignerDetailsType: OpManageSignerDetailsType {
        if let resource = self as? OpCreateSignerDetailsResource {
            return .opCreateSignerDetails(resource)
        } else if let resource = self as? OpRemoveSignerDetailsResource {
            return .opRemoveSignerDetails(resource)
        } else if let resource = self as? OpUpdateSignerDetailsResource {
            return .opUpdateSignerDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateSignerDetails(let resource):
        
        
    case .opRemoveSignerDetails(let resource):
        
        
    case .opUpdateSignerDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
