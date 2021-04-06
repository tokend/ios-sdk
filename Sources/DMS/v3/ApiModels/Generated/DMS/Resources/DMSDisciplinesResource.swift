// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DisciplinesResource

extension DMS {
open class DisciplinesResource: Resource {
    
    open override class var resourceType: String {
        return "disciplines"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case name
    }
    
    // MARK: Attributes
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
}
}
