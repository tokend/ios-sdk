// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ScheduledPaymentRecordDescriptionResource

extension Recpayments {
open class ScheduledPaymentRecordDescriptionResource: Resource {
    
    open override class var resourceType: String {
        return "scheduled-payment-record-description"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case nextTimeSend
        case rRule
    }
    
    // MARK: Attributes
    
    open var nextTimeSend: Date {
        return self.dateOptionalValue(key: CodingKeys.nextTimeSend) ?? Date()
    }
    
    open var rRule: String {
        return self.stringOptionalValue(key: CodingKeys.rRule) ?? ""
    }
    
}
}
