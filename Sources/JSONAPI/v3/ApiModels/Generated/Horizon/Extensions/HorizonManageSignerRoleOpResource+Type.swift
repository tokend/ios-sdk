// Auto-generated code. Do not edit.

import Foundation

public enum ManageSignerRoleOpType {
    
    case operationsCreateSignerRole(_ resource: Horizon.OperationsCreateSignerRoleResource)
    case operationsRemoveSignerRole(_ resource: Horizon.OperationsRemoveSignerRoleResource)
    case operationsUpdateSignerRole(_ resource: Horizon.OperationsUpdateSignerRoleResource)
    case `self`(_ resource: Horizon.ManageSignerRoleOpResource)
}

extension Horizon.ManageSignerRoleOpResource {
    
    public var manageSignerRoleOpType: ManageSignerRoleOpType {
        if let resource = self as? Horizon.OperationsCreateSignerRoleResource {
            return .operationsCreateSignerRole(resource)
        } else if let resource = self as? Horizon.OperationsRemoveSignerRoleResource {
            return .operationsRemoveSignerRole(resource)
        } else if let resource = self as? Horizon.OperationsUpdateSignerRoleResource {
            return .operationsUpdateSignerRole(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsCreateSignerRole(let resource):
        
        
    case .operationsRemoveSignerRole(let resource):
        
        
    case .operationsUpdateSignerRole(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
