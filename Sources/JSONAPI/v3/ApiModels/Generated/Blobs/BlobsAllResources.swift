// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension Blobs {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            CharlieResource.self,
            DeltaResource.self,
            Asset_descriptionResource.self,
            Kyc_formResource.self,
            AlphaResource.self,
            Nav_updateResource.self,
            BravoResource.self,
            Fund_updateResource.self,
            Identity_mind_rejectResource.self,
            Fund_overviewResource.self,
            Kyc_poaResource.self,
            Fund_documentResource.self,
            Token_termsResource.self,
            BlobResource.self,
            Kyc_id_documentResource.self,
            Token_metricsResource.self
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
