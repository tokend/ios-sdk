import Foundation
import DLJSONAPI

// MARK: - BusinessResource

open class BusinessResource: Resource {
    
    open override class var resourceType: String {
        return "businesses"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case name
        case accountId
        case logoLink
    }
    
    // MARK: Attributes
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var logoLink: String {
        return self.stringOptionalValue(key: CodingKeys.logoLink) ?? ""
    }
}
