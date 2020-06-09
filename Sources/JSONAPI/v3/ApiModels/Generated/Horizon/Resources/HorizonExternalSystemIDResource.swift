// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ExternalSystemIDResource

extension Horizon {
open class ExternalSystemIDResource: Resource {
    
    open override class var resourceType: String {
        return "external-system-ids"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case bindedAt
        case data
        case expiresAt
        case externalSystemType
        case isDeleted
        
        // relations
        case account
    }
    
    // MARK: Attributes
    
    open var bindedAt: Date {
        return self.dateOptionalValue(key: CodingKeys.bindedAt) ?? Date()
    }
    
    open var data: Horizon.ExternalSystemData? {
        return self.codableOptionalValue(key: CodingKeys.data)
    }
    
    open var expiresAt: Date {
        return self.dateOptionalValue(key: CodingKeys.expiresAt) ?? Date()
    }
    
    open var externalSystemType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.externalSystemType) ?? 0
    }
    
    open var isDeleted: Bool {
        return self.boolOptionalValue(key: CodingKeys.isDeleted) ?? false
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
}
}
