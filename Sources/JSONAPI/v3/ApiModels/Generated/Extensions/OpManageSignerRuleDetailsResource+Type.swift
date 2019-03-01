// Auto-generated code. Do not edit.

import Foundation

public enum OpManageSignerRuleDetailsType {
    
    case opCreateSignerRuleDetails(_ resource: OpCreateSignerRuleDetailsResource)
    case opRemoveSignerRuleDetails(_ resource: OpRemoveSignerRuleDetailsResource)
    case opUpdateSignerRuleDetails(_ resource: OpUpdateSignerRuleDetailsResource)
    case `self`(_ resource: OpManageSignerRuleDetailsResource)
}

extension OpManageSignerRuleDetailsResource {
    
    public var opManageSignerRuleDetailsType: OpManageSignerRuleDetailsType {
        if let resource = self as? OpCreateSignerRuleDetailsResource {
            return .opCreateSignerRuleDetails(resource)
        } else if let resource = self as? OpRemoveSignerRuleDetailsResource {
            return .opRemoveSignerRuleDetails(resource)
        } else if let resource = self as? OpUpdateSignerRuleDetailsResource {
            return .opUpdateSignerRuleDetails(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .opCreateSignerRuleDetails(let resource):
        
        
    case .opRemoveSignerRuleDetails(let resource):
        
        
    case .opUpdateSignerRuleDetails(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
