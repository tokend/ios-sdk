// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateCloseDeferredPaymentRequestOpResource

extension Horizon {
open class CreateCloseDeferredPaymentRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-close-deferred-payment-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case deferredPayment
        case destinationAccount
        case destinationBalance
        case request
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var deferredPayment: Horizon.DeferredPaymentResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.deferredPayment)
    }
    
    open var destinationAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationAccount)
    }
    
    open var destinationBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationBalance)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
