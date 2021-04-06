// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - DocumentStatusesResource

extension DMS {
open class DocumentStatusesResource: Resource {
    
    open override class var resourceType: String {
        return "document_statuses"
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
