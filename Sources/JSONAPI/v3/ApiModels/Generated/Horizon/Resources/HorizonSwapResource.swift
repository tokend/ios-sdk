// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SwapResource

extension Horizon {
open class SwapResource: Resource {
    
    open override class var resourceType: String {
        return "swaps"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case createdAt
        case destinationFee
        case details
        case lockTime
        case secret
        case secretHash
        case sourceFee
        case state
        
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
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
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
    
    open var secret: String? {
        return self.stringOptionalValue(key: CodingKeys.secret)
    }
    
    open var secretHash: String {
        return self.stringOptionalValue(key: CodingKeys.secretHash) ?? ""
    }
    
    open var sourceFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.sourceFee)
    }
    
    open var state: Int32 {
        return self.int32OptionalValue(key: CodingKeys.state) ?? 0
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
