// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDeferredPaymentRequestResource

extension Horizon {
open class CreateDeferredPaymentRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-create-deferred-payment"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case destinationAccount
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var destinationAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationAccount)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
