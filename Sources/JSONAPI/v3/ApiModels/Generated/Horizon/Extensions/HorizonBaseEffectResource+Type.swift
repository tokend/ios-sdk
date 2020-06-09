// Auto-generated code. Do not edit.

import Foundation

public enum BaseEffectType {
    
    case effectBalanceChange(_ resource: Horizon.EffectBalanceChangeResource)
    case effectMatched(_ resource: Horizon.EffectMatchedResource)
    case `self`(_ resource: Horizon.BaseEffectResource)
}

extension Horizon.BaseEffectResource {
    
    public var baseEffectType: BaseEffectType {
        if let resource = self as? Horizon.EffectBalanceChangeResource {
            return .effectBalanceChange(resource)
        } else if let resource = self as? Horizon.EffectMatchedResource {
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
