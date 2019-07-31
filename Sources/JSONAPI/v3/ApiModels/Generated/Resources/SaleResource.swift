// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SaleResource

open class SaleResource: Resource {
    
    open override class var resourceType: String {
        return "sales"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accessDefinitionType
        case baseHardCap
        case details
        case endTime
        case saleState
        case saleType
        case startTime
        
        // relations
        case baseAsset
        case defaultQuoteAsset
        case owner
        case quoteAssets
    }
    
    // MARK: Attributes
    
    open var accessDefinitionType: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.accessDefinitionType)
    }
    
    open var baseHardCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.baseHardCap) ?? 0.0
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var saleState: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.saleState)
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
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var quoteAssets: [SaleQuoteAssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
}
