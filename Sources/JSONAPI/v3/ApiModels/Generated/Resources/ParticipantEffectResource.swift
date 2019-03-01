// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ParticipantEffectResource

open class ParticipantEffectResource: Resource {
    
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
    
    open var account: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var balance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balance)
    }
    
    open var effect: EffectResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.effect)
    }
    
    open var operation: OperationResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.operation)
    }
    
}
