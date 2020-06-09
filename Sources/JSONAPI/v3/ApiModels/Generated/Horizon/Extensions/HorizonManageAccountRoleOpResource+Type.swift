// Auto-generated code. Do not edit.

import Foundation

public enum ManageAccountRoleOpType {
    
    case operationsCreateAccountRole(_ resource: Horizon.OperationsCreateAccountRoleResource)
    case operationsRemoveAccountRole(_ resource: Horizon.OperationsRemoveAccountRoleResource)
    case operationsUpdateAccountRole(_ resource: Horizon.OperationsUpdateAccountRoleResource)
    case `self`(_ resource: Horizon.ManageAccountRoleOpResource)
}

extension Horizon.ManageAccountRoleOpResource {
    
    public var manageAccountRoleOpType: ManageAccountRoleOpType {
        if let resource = self as? Horizon.OperationsCreateAccountRoleResource {
            return .operationsCreateAccountRole(resource)
        } else if let resource = self as? Horizon.OperationsRemoveAccountRoleResource {
            return .operationsRemoveAccountRole(resource)
        } else if let resource = self as? Horizon.OperationsUpdateAccountRoleResource {
            return .operationsUpdateAccountRole(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsCreateAccountRole(let resource):
        
        
    case .operationsRemoveAccountRole(let resource):
        
        
    case .operationsUpdateAccountRole(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
