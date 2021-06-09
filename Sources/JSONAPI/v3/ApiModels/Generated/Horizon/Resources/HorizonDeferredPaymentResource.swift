// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DeferredPaymentResource

extension Horizon {
open class DeferredPaymentResource: Resource {
    
    open override class var resourceType: String {
        return "deferred-payments"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case details
        case state
        case stateI
        
        // relations
        case asset
        case destination
        case source
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var state: String {
        return self.stringOptionalValue(key: CodingKeys.state) ?? ""
    }
    
    open var stateI: Int32 {
        return self.int32OptionalValue(key: CodingKeys.stateI) ?? 0
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var destination: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destination)
    }
    
    open var source: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.source)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
