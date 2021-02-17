// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ScheduledPaymentRecordResource

extension Recpayments {
open class ScheduledPaymentRecordResource: Resource {
    
    open override class var resourceType: String {
        return "scheduled-payment-record"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case lastPayment
        
        // relations
        case description
        case destinationAccount
        case destinationBalance
        case sourceAccount
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var lastPayment: Date? {
        return self.dateOptionalValue(key: CodingKeys.lastPayment)
    }
    
    // MARK: Relations
    
    open var description: Recpayments.ScheduledPaymentRecordDescriptionResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.description)
    }
    
    open var destinationAccount: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationAccount)
    }
    
    open var destinationBalance: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationBalance)
    }
    
    open var sourceAccount: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceAccount)
    }
    
    open var sourceBalance: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceBalance)
    }
    
}
}
