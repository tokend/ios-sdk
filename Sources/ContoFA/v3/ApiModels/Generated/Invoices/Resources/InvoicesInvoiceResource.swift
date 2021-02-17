// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InvoiceResource

extension Invoices {
open class InvoiceResource: Resource {
    
    open override class var resourceType: String {
        return "invoices"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case cancelledAt
        case completedAt
        case createdAt
        case reference
        case rejectedAt
        case state
        case subject
        
        // relations
        case asset
        case data
        case destinationBalance
        case requestor
        case target
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var cancelledAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.cancelledAt)
    }
    
    open var completedAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.completedAt)
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    open var rejectedAt: Date? {
        return self.dateOptionalValue(key: CodingKeys.rejectedAt)
    }
    
    open var state: Invoices.Enum? {
        return self.codableOptionalValue(key: CodingKeys.state)
    }
    
    open var subject: String {
        return self.stringOptionalValue(key: CodingKeys.subject) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var data: Invoices.DataResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.data)
    }
    
    open var destinationBalance: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationBalance)
    }
    
    open var requestor: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.requestor)
    }
    
    open var target: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.target)
    }
    
}
}
