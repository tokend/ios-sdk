// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAccountRole {
    
    case createAccountOp(_ resource: Horizon.CreateAccountOpResource)
    case createChangeRoleRequestOp(_ resource: Horizon.CreateChangeRoleRequestOpResource)
    case manageAccountRoleOp(_ resource: Horizon.ManageAccountRoleOpResource)
    case manageSignerRoleOp(_ resource: Horizon.ManageSignerRoleOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAccountRole: BaseOperationDetailsRelatedToAccountRole {
        if let resource = self as? Horizon.CreateAccountOpResource {
            return .createAccountOp(resource)
        } else if let resource = self as? Horizon.CreateChangeRoleRequestOpResource {
            return .createChangeRoleRequestOp(resource)
        } else if let resource = self as? Horizon.ManageAccountRoleOpResource {
            return .manageAccountRoleOp(resource)
        } else if let resource = self as? Horizon.ManageSignerRoleOpResource {
            return .manageSignerRoleOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .createAccountOp(let resource):
        
        
    case .createChangeRoleRequestOp(let resource):
        
        
    case .manageAccountRoleOp(let resource):
        
        
    case .manageSignerRoleOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
