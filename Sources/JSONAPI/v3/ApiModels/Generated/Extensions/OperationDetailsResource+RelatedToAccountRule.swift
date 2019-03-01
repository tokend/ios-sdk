// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToAccountRule {
    
    case opManageAccountRoleDetails(_ resource: OpManageAccountRoleDetailsResource)
    case opManageAccountRuleDetails(_ resource: OpManageAccountRuleDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToAccountRule: OperationDetailsRelatedToAccountRule {
        if let resource = self as? OpManageAccountRoleDetailsResource {
            return .opManageAccountRoleDetails(resource)
        } else if let resource = self as? OpManageAccountRuleDetailsResource {
            return .opManageAccountRuleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opManageAccountRoleDetails(let resource):
        
        
    case .opManageAccountRuleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
