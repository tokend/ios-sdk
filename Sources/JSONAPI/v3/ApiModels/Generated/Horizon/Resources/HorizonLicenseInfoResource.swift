// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LicenseInfoResource

extension Horizon {
open class LicenseInfoResource: Resource {
    
    open override class var resourceType: String {
        return "license-info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case adminCount
        case currentAdminCount
        case dueDate
    }
    
    // MARK: Attributes
    
    open var adminCount: Int64 {
        return self.int64OptionalValue(key: CodingKeys.adminCount) ?? 0
    }
    
    open var currentAdminCount: Int64 {
        return self.int64OptionalValue(key: CodingKeys.currentAdminCount) ?? 0
    }
    
    open var dueDate: Date {
        return self.dateOptionalValue(key: CodingKeys.dueDate) ?? Date()
    }
    
}
}
