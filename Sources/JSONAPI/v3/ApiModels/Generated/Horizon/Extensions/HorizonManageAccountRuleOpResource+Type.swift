// Auto-generated code. Do not edit.

import Foundation

public enum ManageAccountRuleOpType {
    
    case operationsCreateAccountRule(_ resource: Horizon.OperationsCreateAccountRuleResource)
    case operationsRemoveAccountRule(_ resource: Horizon.OperationsRemoveAccountRuleResource)
    case operationsUpdateAccountRule(_ resource: Horizon.OperationsUpdateAccountRuleResource)
    case `self`(_ resource: Horizon.ManageAccountRuleOpResource)
}

extension Horizon.ManageAccountRuleOpResource {
    
    public var manageAccountRuleOpType: ManageAccountRuleOpType {
        if let resource = self as? Horizon.OperationsCreateAccountRuleResource {
            return .operationsCreateAccountRule(resource)
        } else if let resource = self as? Horizon.OperationsRemoveAccountRuleResource {
            return .operationsRemoveAccountRule(resource)
        } else if let resource = self as? Horizon.OperationsUpdateAccountRuleResource {
            return .operationsUpdateAccountRule(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .operationsCreateAccountRule(let resource):
        
        
    case .operationsRemoveAccountRule(let resource):
        
        
    case .operationsUpdateAccountRule(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
