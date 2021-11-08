// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateEditionResource

extension Contoparty {
open class CreateEditionResource: Resource {
    
    open override class var resourceType: String {
        return "create-edition"
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
