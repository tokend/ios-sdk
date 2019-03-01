// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OfferResource

open class OfferResource: Resource {
    
    open override class var resourceType: String {
        return "offers"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAmount
        case createdAt
        case fee
        case isBuy
        case orderBookId
        case price
        case quoteAmount
        
        // relations
        case baseAsset
        case baseBalance
        case owner
        case quoteAsset
        case quoteBalance
    }
    
    // MARK: Attributes
    
    open var baseAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAmount) ?? 0.0
    }
    
    open var createdAt: String {
        return self.stringOptionalValue(key: CodingKeys.createdAt) ?? ""
    }
    
    open var fee: Fee? {
        return self.codableOptionalValue(key: CodingKeys.fee)
    }
    
    open var isBuy: Bool {
        return self.boolOptionalValue(key: CodingKeys.isBuy) ?? false
    }
    
    open var orderBookId: String {
        return self.stringOptionalValue(key: CodingKeys.orderBookId) ?? ""
    }
    
    open var price: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.price) ?? 0.0
    }
    
    open var quoteAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.quoteAmount) ?? 0.0
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var baseBalance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseBalance)
    }
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var quoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteAsset)
    }
    
    open var quoteBalance: BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quoteBalance)
    }
    
}
