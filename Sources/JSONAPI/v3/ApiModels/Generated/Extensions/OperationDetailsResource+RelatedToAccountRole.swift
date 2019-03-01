// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToAccountRole {
    
    case opCreateAccountDetails(_ resource: OpCreateAccountDetailsResource)
    case opCreateChangeRoleRequestDetails(_ resource: OpCreateChangeRoleRequestDetailsResource)
    case opManageAccountRoleDetails(_ resource: OpManageAccountRoleDetailsResource)
    case opManageSignerDetails(_ resource: OpManageSignerDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToAccountRole: OperationDetailsRelatedToAccountRole {
        if let resource = self as? OpCreateAccountDetailsResource {
            return .opCreateAccountDetails(resource)
        } else if let resource = self as? OpCreateChangeRoleRequestDetailsResource {
            return .opCreateChangeRoleRequestDetails(resource)
        } else if let resource = self as? OpManageAccountRoleDetailsResource {
            return .opManageAccountRoleDetails(resource)
        } else if let resource = self as? OpManageSignerDetailsResource {
            return .opManageSignerDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateAccountDetails(let resource):
        
        
    case .opCreateChangeRoleRequestDetails(let resource):
        
        
    case .opManageAccountRoleDetails(let resource):
        
        
    case .opManageSignerDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
