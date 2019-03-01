// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - UpdateSaleDetailsRequestDetailsResource

open class UpdateSaleDetailsRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-update-sale-details"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        
        // relations
        case sale
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var sale: SaleResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sale)
    }
    
}
