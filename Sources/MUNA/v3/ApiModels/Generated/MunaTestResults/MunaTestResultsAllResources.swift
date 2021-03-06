// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension MunaTestResults {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            TestResource.self,
            TestTypeResource.self,
            AccountTestTypeResource.self,
            VerificationResource.self
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
