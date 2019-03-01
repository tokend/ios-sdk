// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - WithdrawalRequestDetailsResource

open class WithdrawalRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-withdrawal"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        case fee
        
        // relations
        case balance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var fee: Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    // MARK: Relations
    
    open var balance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balance)
    }
    
}
