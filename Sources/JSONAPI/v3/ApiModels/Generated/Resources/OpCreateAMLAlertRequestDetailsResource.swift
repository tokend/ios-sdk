// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateAMLAlertRequestDetailsResource

open class OpCreateAMLAlertRequestDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-aml-alert"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
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
    
    // MARK: Relations
    
    open var balance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.balance)
    }
    
}
