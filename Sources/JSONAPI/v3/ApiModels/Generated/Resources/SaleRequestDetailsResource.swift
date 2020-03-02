// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SaleRequestDetailsResource

open class SaleRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-sale"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case baseAssetForHardCap
        case creatorDetails
        case endTime
        case saleType
        case startTime
        
        // relations
        case baseAsset
        case defaultQuoteAsset
        case quoteAssets
    }
    
    // MARK: Attributes
    
    open var baseAssetForHardCap: String {
        return self.stringOptionalValue(key: CodingKeys.baseAssetForHardCap) ?? ""
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var saleType: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.saleType)
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var defaultQuoteAsset: SaleQuoteAssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.defaultQuoteAsset)
    }
    
    open var quoteAssets: [SaleQuoteAssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
}
