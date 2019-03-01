// Auto-generated code. Do not edit.

import Foundation

public enum OperationDetailsRelatedToSignerRule {
    
    case opManageSignerRoleDetails(_ resource: OpManageSignerRoleDetailsResource)
    case opManageSignerRuleDetails(_ resource: OpManageSignerRuleDetailsResource)
    case `self`(_ resource: OperationDetailsResource)
}

extension OperationDetailsResource {
    
    public var operationDetailsRelatedToSignerRule: OperationDetailsRelatedToSignerRule {
        if let resource = self as? OpManageSignerRoleDetailsResource {
            return .opManageSignerRoleDetails(resource)
        } else if let resource = self as? OpManageSignerRuleDetailsResource {
            return .opManageSignerRuleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opManageSignerRoleDetails(let resource):
        
        
    case .opManageSignerRuleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
