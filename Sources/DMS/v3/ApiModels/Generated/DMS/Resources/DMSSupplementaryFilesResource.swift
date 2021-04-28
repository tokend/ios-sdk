// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SupplementaryFilesResource

extension DMS {
open class SupplementaryFilesResource: Resource {
    
    open override class var resourceType: String {
        return "supplementary_files"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comment
        case dateAttached
        case file
        case fileChanges
        case fileName
        
        // relations
        case attachedBy
    }
    
    // MARK: Attributes
    
    open var comment: String? {
        return self.stringOptionalValue(key: CodingKeys.comment)
    }
    
    open var dateAttached: Date {
        return self.dateOptionalValue(key: CodingKeys.dateAttached) ?? Date()
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
    
    // MARK: Relations
    
    open var attachedBy: DMS.UserResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.attachedBy)
    }
    
}
}
