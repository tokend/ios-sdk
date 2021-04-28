// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RolePermissionsResource

extension DMS {
open class RolePermissionsResource: Resource {
    
    open override class var resourceType: String {
        return "role_permissions"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
    }
    
    // MARK: Attributes
    
    open var action: String {
        return self.stringOptionalValue(key: CodingKeys.action) ?? ""
    }
    
}
}
