// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageOfferOpResource

extension Horizon {
open class ManageOfferOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-offer"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case fee
        case isBuy
        case isDeleted
        case offerId
        case orderBookId
        case price
        
        // relations
        case baseAsset
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var fee: Horizon.Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var isDeleted: Bool {
        return self.boolOptionalValue(key: CodingKeys.isDeleted) ?? false
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
    
    open var baseAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var quoteAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
}
