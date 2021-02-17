// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TestTypeResource

extension MunaTestResults {
open class TestTypeResource: Resource {
    
    open override class var resourceType: String {
        return "test_type"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
//        case id
        case name
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
//    open var id: Int32 {
//        return self.int32OptionalValue(key: CodingKeys.id) ?? 0
//    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
}
}
