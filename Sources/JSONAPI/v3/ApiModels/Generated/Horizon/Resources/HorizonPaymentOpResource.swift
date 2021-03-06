// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PaymentOpResource

extension Horizon {
open class PaymentOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-payment"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case destinationFee
        case reference
        case sourceFee
        case sourcePayForDestination
        case subject
        
        // relations
        case accountFrom
        case accountTo
        case asset
        case balanceFrom
        case balanceTo
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var destinationFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.destinationFee)
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    open var sourceFee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.sourceFee)
    }
    
    open var sourcePayForDestination: Bool {
        return self.boolOptionalValue(key: CodingKeys.sourcePayForDestination) ?? false
    }
    
    open var subject: String {
        return self.stringOptionalValue(key: CodingKeys.subject) ?? ""
    }
    
    // MARK: Relations
    
    open var accountFrom: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountFrom)
    }
    
    open var accountTo: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountTo)
    }
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var balanceFrom: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balanceFrom)
    }
    
    open var balanceTo: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balanceTo)
    }
    
}
}
