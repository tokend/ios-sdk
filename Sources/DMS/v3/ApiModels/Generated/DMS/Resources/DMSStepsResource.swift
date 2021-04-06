// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - StepsResource

extension DMS {
open class StepsResource: Resource {
    
    open override class var resourceType: String {
        return "steps"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comments
        case dateCompleted
        case dateDue
        case dateIn
        case documentVersion
        case fileChanges
        case name
        case origDateDue
        case outcome
        case status
        
        // relations
        case assignedTo
        case document
        case reviewer
        case workflow
    }
    
    // MARK: Attributes
    
    open var comments: String? {
        return self.stringOptionalValue(key: CodingKeys.comments)
    }
    
    open var dateCompleted: Date? {
        return self.dateOptionalValue(key: CodingKeys.dateCompleted)
    }
    
    open var dateDue: Date? {
        return self.dateOptionalValue(key: CodingKeys.dateDue)
    }
    
    open var dateIn: Date? {
        return self.dateOptionalValue(key: CodingKeys.dateIn)
    }
    
    open var documentVersion: Int32 {
        return self.int32OptionalValue(key: CodingKeys.documentVersion) ?? 0
    }
    
    open var fileChanges: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.fileChanges)
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var origDateDue: Date {
        return self.dateOptionalValue(key: CodingKeys.origDateDue) ?? Date()
    }
    
    open var outcome: Int32 {
        return self.int32OptionalValue(key: CodingKeys.outcome) ?? 0
    }
    
    open var status: Int32 {
        return self.int32OptionalValue(key: CodingKeys.status) ?? 0
    }
    
    // MARK: Relations
    
    open var assignedTo: [DMS.UserResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.assignedTo)
    }
    
    open var document: DMS.DocumentsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.document)
    }
    
    open var reviewer: DMS.UserResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.reviewer)
    }
    
    open var workflow: DMS.WorkflowsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.workflow)
    }
    
}
}
