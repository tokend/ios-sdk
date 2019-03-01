// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageOfferDetailsResource

open class OpManageOfferDetailsResource: OperationDetailsResource {
    
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
    
    open var fee: Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var isDeleted: Bool {
        return self.boolOptionalValue(key: CodingKeys.isDeleted) ?? false
    }
    
    open var offerId: Int64? {
        return self.int64OptionalValue(key: CodingKeys.offerId)
    }
    
    open var orderBookId: Int64 {
        return self.int64OptionalValue(key: CodingKeys.orderBookId) ?? 0
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
}
