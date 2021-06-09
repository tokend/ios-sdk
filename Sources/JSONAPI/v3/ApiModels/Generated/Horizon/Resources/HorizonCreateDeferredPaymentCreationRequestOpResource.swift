// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateDeferredPaymentCreationRequestOpResource

extension Horizon {
open class CreateDeferredPaymentCreationRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-deferred-payment-creation-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case destinationAccount
        case request
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
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
