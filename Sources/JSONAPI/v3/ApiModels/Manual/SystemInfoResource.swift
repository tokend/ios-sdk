import Foundation
import DLJSONAPI

open class SystemInfoResource: Resource {
    
    open override class var resourceType: String {
        return "invitations-info"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        
        // relations
        case accountId
    }
    
    open var accountId: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.accountId)
    }
}
