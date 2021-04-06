// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AttachSupplementaryFileResource

extension DMS {
open class AttachSupplementaryFileResource: Resource {
    
    open override class var resourceType: String {
        return "attach_supplementary_file"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comment
        case file
        case fileChanges
        case fileName
    }
    
    // MARK: Attributes
    
    open var comment: String? {
        return self.stringOptionalValue(key: CodingKeys.comment)
    }
    
    open var file: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.file) ?? [:]
    }
    
    open var fileChanges: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.fileChanges)
    }
    
    open var fileName: String {
        return self.stringOptionalValue(key: CodingKeys.fileName) ?? ""
    }
    
}
}
