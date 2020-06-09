// Auto-generated code. Do not edit.

import Foundation

public enum BaseOperationDetailsRelatedToAccountRule {
    
    case manageAccountRoleOp(_ resource: Horizon.ManageAccountRoleOpResource)
    case manageAccountRuleOp(_ resource: Horizon.ManageAccountRuleOpResource)
    case manageSignerRoleOp(_ resource: Horizon.ManageSignerRoleOpResource)
    case `self`(_ resource: Horizon.BaseOperationDetailsResource)
}

extension Horizon.BaseOperationDetailsResource {
    
    public var baseOperationDetailsRelatedToAccountRule: BaseOperationDetailsRelatedToAccountRule {
        if let resource = self as? Horizon.ManageAccountRoleOpResource {
            return .manageAccountRoleOp(resource)
        } else if let resource = self as? Horizon.ManageAccountRuleOpResource {
            return .manageAccountRuleOp(resource)
        } else if let resource = self as? Horizon.ManageSignerRoleOpResource {
            return .manageSignerRoleOp(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .manageAccountRoleOp(let resource):
        
        
    case .manageAccountRuleOp(let resource):
        
        
    case .manageSignerRoleOp(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
