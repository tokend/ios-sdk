// Auto-generated code. Do not edit.

import Foundation

public enum EffectBalanceChangeType {
    
    case effectCharged(_ resource: EffectChargedResource)
    case effectChargedFromLocked(_ resource: EffectChargedFromLockedResource)
    case effectFunded(_ resource: EffectFundedResource)
    case effectIssued(_ resource: EffectIssuedResource)
    case effectLocked(_ resource: EffectLockedResource)
    case effectUnlocked(_ resource: EffectUnlockedResource)
    case effectWithdrawn(_ resource: EffectWithdrawnResource)
    case `self`(_ resource: EffectBalanceChangeResource)
}

extension EffectBalanceChangeResource {
    
    public var effectBalanceChangeType: EffectBalanceChangeType {
        if let resource = self as? EffectChargedResource {
            return .effectCharged(resource)
        } else if let resource = self as? EffectChargedFromLockedResource {
            return .effectChargedFromLocked(resource)
        } else if let resource = self as? EffectFundedResource {
            return .effectFunded(resource)
        } else if let resource = self as? EffectIssuedResource {
            return .effectIssued(resource)
        } else if let resource = self as? EffectLockedResource {
            return .effectLocked(resource)
        } else if let resource = self as? EffectUnlockedResource {
            return .effectUnlocked(resource)
        } else if let resource = self as? EffectWithdrawnResource {
            return .effectWithdrawn(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .effectCharged(let resource):
        
        
    case .effectChargedFromLocked(let resource):
        
        
    case .effectFunded(let resource):
        
        
    case .effectIssued(let resource):
        
        
    case .effectLocked(let resource):
        
        
    case .effectUnlocked(let resource):
        
        
    case .effectWithdrawn(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
