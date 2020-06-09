// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RedemptionRequestResource

extension Horizon {
open class RedemptionRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-redemption"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case destination
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
    
    open var destination: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destination)
    }
    
    open var sourceBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
