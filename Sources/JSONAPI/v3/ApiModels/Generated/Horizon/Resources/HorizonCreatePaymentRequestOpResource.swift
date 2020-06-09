// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreatePaymentRequestOpResource

extension Horizon {
open class CreatePaymentRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-payment-request"
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
        case balanceFrom
        case request
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
    
    open var balanceFrom: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balanceFrom)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
