// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension Cards {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            PublicCardListTempViewResource.self,
            UpdateCardResource.self,
            TransactionResource.self,
            CreateCardResource.self,
            CardSecurityDetailsResource.self,
            CardBalanceResource.self,
            InfoResource.self,
            CardResource.self
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
