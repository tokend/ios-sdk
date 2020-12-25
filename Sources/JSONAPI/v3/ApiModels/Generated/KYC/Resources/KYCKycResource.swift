// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - KycResource

extension KYC {
open class KycResource: Resource {
    
    open override class var resourceType: String {
        return "kyc"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case details
        case role
    }
    
    // MARK: Attributes
    
    open var accountId: String {
        return self.stringOptionalValue(key: CodingKeys.accountId) ?? ""
    }
    
    open var details: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.details)
    }
    
    open var role: Int32 {
        return self.int32OptionalValue(key: CodingKeys.role) ?? 0
    }
    
}
}
