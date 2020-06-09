// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - KYCRecoveryRequestResource

extension Horizon {
open class KYCRecoveryRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-kyc-recovery"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case sequenceNumber
        case signersData
        
        // relations
        case targetAccount
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var sequenceNumber: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.sequenceNumber) ?? 0
    }
    
    open var signersData: Horizon.UpdateSignerData? {
        return self.codableOptionalValue(key: CodingKeys.signersData)
    }
    
    // MARK: Relations
    
    open var targetAccount: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.targetAccount)
    }
    
}
}
