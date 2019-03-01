// Auto-generated code. Do not edit.

import Foundation

public enum OpManageSignerRoleDetailsType {
    
    case opCreateSignerRoleDetails(_ resource: OpCreateSignerRoleDetailsResource)
    case opRemoveSignerRoleDetails(_ resource: OpRemoveSignerRoleDetailsResource)
    case opUpdateSignerRoleDetails(_ resource: OpUpdateSignerRoleDetailsResource)
    case `self`(_ resource: OpManageSignerRoleDetailsResource)
}

extension OpManageSignerRoleDetailsResource {
    
    public var opManageSignerRoleDetailsType: OpManageSignerRoleDetailsType {
        if let resource = self as? OpCreateSignerRoleDetailsResource {
            return .opCreateSignerRoleDetails(resource)
        } else if let resource = self as? OpRemoveSignerRoleDetailsResource {
            return .opRemoveSignerRoleDetails(resource)
        } else if let resource = self as? OpUpdateSignerRoleDetailsResource {
            return .opUpdateSignerRoleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateSignerRoleDetails(let resource):
        
        
    case .opRemoveSignerRoleDetails(let resource):
        
        
    case .opUpdateSignerRoleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
