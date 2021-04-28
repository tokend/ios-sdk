// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DocumentTypesResource

extension DMS {
open class DocumentTypesResource: Resource {
    
    open override class var resourceType: String {
        return "document_types"
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
