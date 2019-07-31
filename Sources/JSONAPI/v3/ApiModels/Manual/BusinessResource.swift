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
        case logo
    }
    
    // MARK: Attributes
    
    open var name: String {
        get { return self.stringOptionalValue(key: CodingKeys.name) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.name) }
    }
    
    open var accountId: String {
        get { return self.stringOptionalValue(key: CodingKeys.accountId) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.accountId) }
    }
    
    open var logoJSON: String {
        get { return self.stringOptionalValue(key: CodingKeys.logo) ?? "" }
        set { self.setStringOptionalValue(newValue, key: CodingKeys.logo) }
    }
}
