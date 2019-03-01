// Auto-generated code. Do not edit.

import Foundation

public enum EffectType {
    
    case effectBalanceChange(_ resource: EffectBalanceChangeResource)
    case effectMatched(_ resource: EffectMatchedResource)
    case `self`(_ resource: EffectResource)
}

extension EffectResource {
    
    public var effectType: EffectType {
        if let resource = self as? EffectBalanceChangeResource {
            return .effectBalanceChange(resource)
        } else if let resource = self as? EffectMatchedResource {
            return .effectMatched(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .effectBalanceChange(let resource):
        
        
    case .effectMatched(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
