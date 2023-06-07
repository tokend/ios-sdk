// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - StartKYCResource

extension PlaidIntegration {
open class StartKYCResource: Resource {
    
    open override class var resourceType: String {
        return "start_kyc"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case email
        case redirectUri
    }
    
    // MARK: Attributes
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var email: String {
        return self.stringOptionalValue(key: CodingKeys.email) ?? ""
    }
    
    open var redirectUri: String? {
        return self.stringOptionalValue(key: CodingKeys.redirectUri)
    }
    
}
}
