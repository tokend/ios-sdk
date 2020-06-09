// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AccountKYCResource

extension Horizon {
open class AccountKYCResource: Resource {
    
    open override class var resourceType: String {
        return "account-kyc"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case kycData
    }
    
    // MARK: Attributes
    
    open var kycData: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.kycData) ?? [:]
    }
    
}
}
