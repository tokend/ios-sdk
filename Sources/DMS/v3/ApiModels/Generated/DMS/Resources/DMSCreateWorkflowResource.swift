// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateWorkflowResource

extension DMS {
open class CreateWorkflowResource: Resource {
    
    open override class var resourceType: String {
        return "create_workflow"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case documents
        case name
        case notes
        case projectId
        case stages
        case supplementaryFiles
        case templateId
    }
    
    // MARK: Attributes
    
    open var documents: String {
        return self.stringOptionalValue(key: CodingKeys.documents) ?? ""
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var notes: String? {
        return self.stringOptionalValue(key: CodingKeys.notes)
    }
    
    open var projectId: String {
        return self.stringOptionalValue(key: CodingKeys.projectId) ?? ""
    }
    
    open var stages: DMS.Stage? {
        return self.codableOptionalValue(key: CodingKeys.stages)
    }
    
    open var supplementaryFiles: DMS.CreateWorkflowSupplementaryFile? {
        return self.codableOptionalValue(key: CodingKeys.supplementaryFiles)
    }
    
    open var templateId: String {
        return self.stringOptionalValue(key: CodingKeys.templateId) ?? ""
    }
    
}
}
