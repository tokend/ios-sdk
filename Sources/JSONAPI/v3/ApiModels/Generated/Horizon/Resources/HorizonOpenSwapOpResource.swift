// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpenSwapOpResource

extension Horizon {
open class OpenSwapOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-open-swap"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case destinationFee
        case details
        case lockTime
        case secretHash
        case sourceFee
        case sourcePayForDestination
        
        // relations
        case asset
        case destination
        case destinationBalance
        case source
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var destinationFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.destinationFee)
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var lockTime: Date {
        return self.dateOptionalValue(key: CodingKeys.lockTime) ?? Date()
    }
    
    open var secretHash: String {
        return self.stringOptionalValue(key: CodingKeys.secretHash) ?? ""
    }
    
    open var sourceFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.sourceFee)
    }
    
    open var sourcePayForDestination: Bool {
        return self.boolOptionalValue(key: CodingKeys.sourcePayForDestination) ?? false
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var destination: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destination)
    }
    
    open var destinationBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationBalance)
    }
    
    open var source: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.source)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
