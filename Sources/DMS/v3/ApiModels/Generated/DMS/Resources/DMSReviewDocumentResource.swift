// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ReviewDocumentResource

extension DMS {
open class ReviewDocumentResource: Resource {
    
    open override class var resourceType: String {
        return "review_document"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comments
        case documentVersion
        case fileChanges
        case outcome
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
    
    open var outcome: Int32 {
        return self.int32OptionalValue(key: CodingKeys.outcome) ?? 0
    }
    
}
}
