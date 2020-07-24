// Auto-generated code. Do not edit.

import Foundation

public enum ManageSignerRuleOpType {
    
    case operationsCreateSignerRule(_ resource: Horizon.OperationsCreateSignerRuleResource)
    case operationsRemoveSignerRule(_ resource: Horizon.OperationsRemoveSignerRuleResource)
    case operationsUpdateSignerRule(_ resource: Horizon.OperationsUpdateSignerRuleResource)
    case `self`(_ resource: Horizon.ManageSignerRuleOpResource)
}

extension Horizon.ManageSignerRuleOpResource {
    
    public var manageSignerRuleOpType: ManageSignerRuleOpType {
        if let resource = self as? Horizon.OperationsCreateSignerRuleResource {
            return .operationsCreateSignerRule(resource)
        } else if let resource = self as? Horizon.OperationsRemoveSignerRuleResource {
            return .operationsRemoveSignerRule(resource)
        } else if let resource = self as? Horizon.OperationsUpdateSignerRuleResource {
            return .operationsUpdateSignerRule(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsCreateSignerRule(let resource):
        
        
    case .operationsRemoveSignerRule(let resource):
        
        
    case .operationsUpdateSignerRule(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
