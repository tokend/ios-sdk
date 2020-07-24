// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateKYCRecoveryRequestOpResource

extension Horizon {
open class CreateKYCRecoveryRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-kyc-recovery-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case allTasks
        case creatorDetails
        case signersData
        
        // relations
        case request
        case targetAccount
    }
    
    // MARK: Attributes
    
    open var allTasks: UInt32? {
        return self.uint32OptionalValue(key: CodingKeys.allTasks)
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var signersData: Horizon.UpdateSignerData? {
        return self.codableOptionalValue(key: CodingKeys.signersData)
    }
    
    // MARK: Relations
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
    open var targetAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.targetAccount)
    }
    
}
}
