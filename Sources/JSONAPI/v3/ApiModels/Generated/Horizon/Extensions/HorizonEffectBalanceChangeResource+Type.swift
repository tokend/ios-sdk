// Auto-generated code. Do not edit.

import Foundation

public enum EffectBalanceChangeType {
    
    case effectsCharged(_ resource: Horizon.EffectsChargedResource)
    case effectsChargedFromLocked(_ resource: Horizon.EffectsChargedFromLockedResource)
    case effectsFunded(_ resource: Horizon.EffectsFundedResource)
    case effectsIssued(_ resource: Horizon.EffectsIssuedResource)
    case effectsLocked(_ resource: Horizon.EffectsLockedResource)
    case effectsUnlocked(_ resource: Horizon.EffectsUnlockedResource)
    case effectsWithdrawn(_ resource: Horizon.EffectsWithdrawnResource)
    case `self`(_ resource: Horizon.EffectBalanceChangeResource)
}

extension Horizon.EffectBalanceChangeResource {
    
    public var effectBalanceChangeType: EffectBalanceChangeType {
        if let resource = self as? Horizon.EffectsChargedResource {
            return .effectsCharged(resource)
        } else if let resource = self as? Horizon.EffectsChargedFromLockedResource {
            return .effectsChargedFromLocked(resource)
        } else if let resource = self as? Horizon.EffectsFundedResource {
            return .effectsFunded(resource)
        } else if let resource = self as? Horizon.EffectsIssuedResource {
            return .effectsIssued(resource)
        } else if let resource = self as? Horizon.EffectsLockedResource {
            return .effectsLocked(resource)
        } else if let resource = self as? Horizon.EffectsUnlockedResource {
            return .effectsUnlocked(resource)
        } else if let resource = self as? Horizon.EffectsWithdrawnResource {
            return .effectsWithdrawn(resource)
        } else {
            return .`self`(self)
        }
    }
}

/*
    switch type {
        
    case .effectsCharged(let resource):
        
        
    case .effectsChargedFromLocked(let resource):
        
        
    case .effectsFunded(let resource):
        
        
    case .effectsIssued(let resource):
        
        
    case .effectsLocked(let resource):
        
        
    case .effectsUnlocked(let resource):
        
        
    case .effectsWithdrawn(let resource):
        
        
    case .`self`(let resource):
        
    }
*/
