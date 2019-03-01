// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - PreIssuanceRequestDetailsResource

open class PreIssuanceRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-pre-issuance"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        case reference
        case signature
        
        // relations
        case asset
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var reference: String {
        return self.stringOptionalValue(key: CodingKeys.reference) ?? ""
    }
    
    open var signature: String {
        return self.stringOptionalValue(key: CodingKeys.signature) ?? ""
    }
    
    // MARK: Relations
    
    open var asset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
