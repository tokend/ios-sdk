// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ParticipantsEffectResource

extension Horizon {
open class ParticipantsEffectResource: Resource {
    
    open override class var resourceType: String {
        return "participant-effects"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case account
        case asset
        case balance
        case effect
        case operation
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var balance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balance)
    }
    
    open var effect: Horizon.BaseEffectResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.effect)
    }
    
    open var operation: Horizon.OperationResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.operation)
    }
    
}
}
