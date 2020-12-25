// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension MunaTestResults {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            Fund_documentResource.self,
            BravoResource.self,
            Fund_overviewResource.self,
            Nav_updateResource.self,
            Fund_updateResource.self,
            CharlieResource.self,
            TestResource.self,
            Token_termsResource.self,
            DeltaResource.self,
            TestTypeResource.self,
            BlobResource.self,
            AlphaResource.self,
            Asset_descriptionResource.self,
            Kyc_id_documentResource.self,
            Kyc_formResource.self,
            AccountTestTypeResource.self,
            VerificationResource.self,
            Identity_mind_rejectResource.self,
            Kyc_poaResource.self,
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
