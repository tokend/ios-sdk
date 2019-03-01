// Auto-generated code. Do not edit.

import Foundation

public enum OpManageAccountRuleDetailsType {
    
    case opCreateAccountRuleDetails(_ resource: OpCreateAccountRuleDetailsResource)
    case opRemoveAccountRuleDetails(_ resource: OpRemoveAccountRuleDetailsResource)
    case opUpdateAccountRuleDetails(_ resource: OpUpdateAccountRuleDetailsResource)
    case `self`(_ resource: OpManageAccountRuleDetailsResource)
}

extension OpManageAccountRuleDetailsResource {
    
    public var opManageAccountRuleDetailsType: OpManageAccountRuleDetailsType {
        if let resource = self as? OpCreateAccountRuleDetailsResource {
            return .opCreateAccountRuleDetails(resource)
        } else if let resource = self as? OpRemoveAccountRuleDetailsResource {
            return .opRemoveAccountRuleDetails(resource)
        } else if let resource = self as? OpUpdateAccountRuleDetailsResource {
            return .opUpdateAccountRuleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateAccountRuleDetails(let resource):
        
        
    case .opRemoveAccountRuleDetails(let resource):
        
        
    case .opUpdateAccountRuleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
