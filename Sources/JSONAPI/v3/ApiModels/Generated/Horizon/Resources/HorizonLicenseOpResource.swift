// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LicenseOpResource

extension Horizon {
open class LicenseOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-license"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case adminCount
        case dueDate
        case ledgerHash
        case prevLicenseHash
        case signatures
    }
    
    // MARK: Attributes
    
    open var adminCount: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.adminCount) ?? 0
    }
    
    open var dueDate: Date {
        return self.dateOptionalValue(key: CodingKeys.dueDate) ?? Date()
    }
    
    open var ledgerHash: String {
        return self.stringOptionalValue(key: CodingKeys.ledgerHash) ?? ""
    }
    
    open var prevLicenseHash: String {
        return self.stringOptionalValue(key: CodingKeys.prevLicenseHash) ?? ""
    }
    
    open var signatures: String {
        return self.stringOptionalValue(key: CodingKeys.signatures) ?? ""
    }
    
}
}
