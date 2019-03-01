// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - IssuanceRequestDetailsResource

open class IssuanceRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-issuance"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case asset
        case receiver
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var receiver: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.receiver)
    }
    
}
