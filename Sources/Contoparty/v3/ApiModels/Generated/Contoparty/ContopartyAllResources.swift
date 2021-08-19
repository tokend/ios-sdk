// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension Contoparty {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            TransactionResource.self,
            TokenHistoryResource.self,
            ExternalIdResource.self,
            TokenResource.self,
            DraftTokenResource.self,
            CreateDraftTokenResource.self,
            EditionResource.self
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
