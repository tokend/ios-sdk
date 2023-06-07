// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - KYCStatusResource

extension PlaidIntegration {
open class KYCStatusResource: Resource {
    
    open override class var resourceType: String {
        return "kyc-status"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case status
    }
    
    // MARK: Attributes
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var status: String {
        return self.stringOptionalValue(key: CodingKeys.status) ?? ""
    }
    
}
}
