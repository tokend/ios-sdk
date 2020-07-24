// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreatePreIssuanceRequestOpResource

extension Horizon {
open class CreatePreIssuanceRequestOpResource: Resource {
    
    open override class var resourceType: String {
        return "operations-create-preissuance-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case asset
        case request
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails)
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
