// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - VaccineTypeResource

extension MunaVaccineResults {
open class VaccineTypeResource: Resource {
    
    open override class var resourceType: String {
        return "vaccine_type"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case name
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
}
}
