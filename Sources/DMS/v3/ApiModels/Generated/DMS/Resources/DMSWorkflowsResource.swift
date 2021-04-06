// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - WorkflowsResource

extension DMS {
open class WorkflowsResource: Resource {
    
    open override class var resourceType: String {
        return "workflows"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case canEditInProgress
        case canEditOnStart
        case canSkipInProgress
        case endDate
        case name
        case notes
        case number
        case outcomePolicy
        case stages
        case startDate
        case template
        
        // relations
        case documents
        case initiator
        case project
        case supplementaryFiles
    }
    
    // MARK: Attributes
    
    open var canEditInProgress: Bool {
        return self.boolOptionalValue(key: CodingKeys.canEditInProgress) ?? false
    }
    
    open var canEditOnStart: Bool {
        return self.boolOptionalValue(key: CodingKeys.canEditOnStart) ?? false
    }
    
    open var canSkipInProgress: Bool {
        return self.boolOptionalValue(key: CodingKeys.canSkipInProgress) ?? false
    }
    
    open var endDate: Date {
        return self.dateOptionalValue(key: CodingKeys.endDate) ?? Date()
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var notes: String {
        return self.stringOptionalValue(key: CodingKeys.notes) ?? ""
    }
    
    open var number: String {
        return self.stringOptionalValue(key: CodingKeys.number) ?? ""
    }
    
    open var outcomePolicy: Int32 {
        return self.int32OptionalValue(key: CodingKeys.outcomePolicy) ?? 0
    }
    
    open var stages: DMS.Stage? {
        return self.codableOptionalValue(key: CodingKeys.stages)
    }
    
    open var startDate: Date {
        return self.dateOptionalValue(key: CodingKeys.startDate) ?? Date()
    }
    
    open var template: String {
        return self.stringOptionalValue(key: CodingKeys.template) ?? ""
    }
    
    // MARK: Relations
    
    open var documents: [DMS.DocumentsResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.documents)
    }
    
    open var initiator: DMS.UserResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.initiator)
    }
    
    open var project: DMS.ProjectsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.project)
    }
    
    open var supplementaryFiles: [DMS.SupplementaryFilesResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.supplementaryFiles)
    }
    
}
}
