// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreatePaymentRequestResource

extension Horizon {
open class CreatePaymentRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-create-payment"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        case destinationFee
        case reference
        case sourceFee
        case sourcePayForDestination
        case subject
        
        // relations
        case balanceFrom
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
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
    
    open var balanceFrom: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balanceFrom)
    }
    
}
}
