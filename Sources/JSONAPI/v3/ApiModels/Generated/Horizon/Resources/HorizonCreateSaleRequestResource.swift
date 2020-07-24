// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateSaleRequestResource

extension Horizon {
open class CreateSaleRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-sale"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accessDefinitionType
        case baseAssetForHardCap
        case creatorDetails
        case endTime
        case hardCap
        case saleType
        case softCap
        case startTime
        
        // relations
        case baseAsset
        case defaultQuoteAsset
        case quoteAssets
    }
    
    // MARK: Attributes
    
    open var accessDefinitionType: String {
        return self.stringOptionalValue(key: CodingKeys.accessDefinitionType) ?? ""
    }
    
    open var baseAssetForHardCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseAssetForHardCap) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var hardCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.hardCap) ?? 0.0
    }
    
    open var saleType: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.saleType)
    }
    
    open var softCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.softCap) ?? 0.0
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    // MARK: Relations
    
    open var baseAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var defaultQuoteAsset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.defaultQuoteAsset)
    }
    
    open var quoteAssets: [Horizon.AssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
}
}
