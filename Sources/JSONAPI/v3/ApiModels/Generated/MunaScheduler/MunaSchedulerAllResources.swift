// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

extension MunaScheduler {
enum AllResources {
    
    // swiftlint:disable function_body_length
    public static func registerAllResources() {
        let allResources: [Resource.Type] = [
            EventResource.self,
            EventRecurrenceResource.self,
            FreeBusyResource.self,
            CalendarResource.self
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
