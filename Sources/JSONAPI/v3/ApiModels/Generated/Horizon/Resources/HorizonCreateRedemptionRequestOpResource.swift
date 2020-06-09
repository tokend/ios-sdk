// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateRedemptionRequestOpResource

extension Horizon {
open class CreateRedemptionRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-redemption-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case accountTo
        case balanceFrom
        case request
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: String {
        return self.stringOptionalValue(key: CodingKeys.creatorDetails) ?? ""
    }
    
    // MARK: Relations
    
    open var accountTo: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountTo)
    }
    
    open var balanceFrom: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balanceFrom)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
