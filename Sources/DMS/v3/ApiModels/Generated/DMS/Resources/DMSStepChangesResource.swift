// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - StepChangesResource

extension DMS {
open class StepChangesResource: Resource {
    
    open override class var resourceType: String {
        return "step_changes"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comments
        case documentVersion
        case fileChanges
    }
    
    // MARK: Attributes
    
    open var comments: String? {
        return self.stringOptionalValue(key: CodingKeys.comments)
    }
    
    open var documentVersion: Int32 {
        return self.int32OptionalValue(key: CodingKeys.documentVersion) ?? 0
    }
    
    open var fileChanges: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.fileChanges)
    }
    
}
}
