// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateManageOfferRequestOpResource

extension Horizon {
open class CreateManageOfferRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-manage-offer-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case creatorDetails
        case fee
        case isBuy
        case offerId
        case orderBookId
        case price
        
        // relations
        case request
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var fee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var offerId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.offerId) ?? 0
    }
    
    open var orderBookId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.orderBookId) ?? 0
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    // MARK: Relations
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
