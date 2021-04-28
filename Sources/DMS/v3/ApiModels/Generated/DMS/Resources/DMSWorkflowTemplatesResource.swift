// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - WorkflowTemplatesResource

extension DMS {
open class WorkflowTemplatesResource: Resource {
    
    open override class var resourceType: String {
        return "workflow_templates"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case canEditInProgress
        case canEditOnStart
        case canSkipInProgress
        case defaultCompletionRule
        case defaultRejectionPolicy
        case name
        case notes
        case outcomePolicy
        case projectId
        case stages
        case status
        case totalDuration
    }
    
    // MARK: Attributes
    
    open var canEditInProgress: Bool? {
        return self.boolOptionalValue(key: CodingKeys.canEditInProgress)
    }
    
    open var canEditOnStart: Bool? {
        return self.boolOptionalValue(key: CodingKeys.canEditOnStart)
    }
    
    open var canSkipInProgress: Bool? {
        return self.boolOptionalValue(key: CodingKeys.canSkipInProgress)
    }
    
    open var defaultCompletionRule: Int32? {
        return self.int32OptionalValue(key: CodingKeys.defaultCompletionRule)
    }
    
    open var defaultRejectionPolicy: Int32? {
        return self.int32OptionalValue(key: CodingKeys.defaultRejectionPolicy)
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var notes: String? {
        return self.stringOptionalValue(key: CodingKeys.notes)
    }
    
    open var outcomePolicy: Int32? {
        return self.int32OptionalValue(key: CodingKeys.outcomePolicy)
    }
    
    open var projectId: String {
        return self.stringOptionalValue(key: CodingKeys.projectId) ?? ""
    }
    
    open var stages: DMS.Stage? {
        return self.codableOptionalValue(key: CodingKeys.stages)
    }
    
    open var status: Int32 {
        return self.int32OptionalValue(key: CodingKeys.status) ?? 0
    }
    
    open var totalDuration: Int32? {
        return self.int32OptionalValue(key: CodingKeys.totalDuration)
    }
    
}
}
