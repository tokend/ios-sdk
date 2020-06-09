// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - InitiateKYCRecoveryOpResource

extension Horizon {
open class InitiateKYCRecoveryOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-initiate-kyc-recovery"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case signer
        
        // relations
        case account
    }
    
    // MARK: Attributes
    
    open var signer: String {
        return self.stringOptionalValue(key: CodingKeys.signer) ?? ""
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
}
}
