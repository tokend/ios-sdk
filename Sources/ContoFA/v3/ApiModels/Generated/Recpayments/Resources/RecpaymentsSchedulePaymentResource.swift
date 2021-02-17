// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SchedulePaymentResource

extension Recpayments {
open class SchedulePaymentResource: Resource {
    
    open override class var resourceType: String {
        return "schedule-payments-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case destinationType
        case rRule
        case sendImmediately
        
        // relations
        case destinationAccount
        case destinationBalance
        case sourceAccount
        case sourceBalance
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var destinationType: Recpayments.Enum? {
        return self.codableOptionalValue(key: CodingKeys.destinationType)
    }
    
    open var rRule: String {
        return self.stringOptionalValue(key: CodingKeys.rRule) ?? ""
    }
    
    open var sendImmediately: Bool {
        return self.boolOptionalValue(key: CodingKeys.sendImmediately) ?? false
    }
    
    // MARK: Relations
    
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
