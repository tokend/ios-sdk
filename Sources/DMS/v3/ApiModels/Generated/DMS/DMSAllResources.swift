// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension DMS {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            EventResource.self,
            WorkflowsResource.self,
            DocumentStatusesResource.self,
            ProjectsResource.self,
            StepChangesResource.self,
            WorkflowTemplatesResource.self,
            StepsResource.self,
            UserResource.self,
            SupplementaryFilesResource.self,
            ReviewDocumentResource.self,
            RolePermissionsResource.self,
            OrganizationInfoResource.self,
            DocumentsResource.self,
            CreateWorkflowResource.self,
            AttachSupplementaryFileResource.self,
            DocumentTypesResource.self,
            DisciplinesResource.self
        ]
        
        for res in allResources {
            Context.registerClass(res)
        }
        
        for res in ManualResources.resources {
            Context.registerClass(res)
        }
    }
    // swiftlint:enable function_body_length
}
}
