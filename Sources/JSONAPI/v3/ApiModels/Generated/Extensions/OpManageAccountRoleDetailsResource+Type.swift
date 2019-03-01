// Auto-generated code. Do not edit.

import Foundation

public enum OpManageAccountRoleDetailsType {
    
    case opCreateAccountRoleDetails(_ resource: OpCreateAccountRoleDetailsResource)
    case opRemoveAccountRoleDetails(_ resource: OpRemoveAccountRoleDetailsResource)
    case opUpdateAccountRoleDetails(_ resource: OpUpdateAccountRoleDetailsResource)
    case `self`(_ resource: OpManageAccountRoleDetailsResource)
}

extension OpManageAccountRoleDetailsResource {
    
    public var opManageAccountRoleDetailsType: OpManageAccountRoleDetailsType {
        if let resource = self as? OpCreateAccountRoleDetailsResource {
            return .opCreateAccountRoleDetails(resource)
        } else if let resource = self as? OpRemoveAccountRoleDetailsResource {
            return .opRemoveAccountRoleDetails(resource)
        } else if let resource = self as? OpUpdateAccountRoleDetailsResource {
            return .opUpdateAccountRoleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateAccountRoleDetails(let resource):
        
        
    case .opRemoveAccountRoleDetails(let resource):
        
        
    case .opUpdateAccountRoleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
