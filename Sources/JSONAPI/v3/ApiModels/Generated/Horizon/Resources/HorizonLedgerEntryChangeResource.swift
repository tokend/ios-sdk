// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LedgerEntryChangeResource

extension Horizon {
open class LedgerEntryChangeResource: Resource {
    
    open override class var resourceType: String {
        return "ledger-entry-changes"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case changeType
        case entryType
        case payload
    }
    
    // MARK: Attributes
    
    open var changeType: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.changeType)
    }
    
    open var entryType: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.entryType)
    }
    
    open var payload: String {
        return self.stringOptionalValue(key: CodingKeys.payload) ?? ""
    }
    
}
}
