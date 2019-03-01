// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpCreateSaleRequestDetailsResource

open class OpCreateSaleRequestDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-sale-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creatorDetails
        case endTime
        case hardCap
        case softCap
        case startTime
        
        // relations
        case baseAsset
        case defaultQuoteAsset
        case quoteAssets
        case request
    }
    
    // MARK: Attributes
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var endTime: Date {
        return self.dateOptionalValue(key: CodingKeys.endTime) ?? Date()
    }
    
    open var hardCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.hardCap) ?? 0.0
    }
    
    open var softCap: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.softCap) ?? 0.0
    }
    
    open var startTime: Date {
        return self.dateOptionalValue(key: CodingKeys.startTime) ?? Date()
    }
    
    // MARK: Relations
    
    open var baseAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseAsset)
    }
    
    open var defaultQuoteAsset: AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.defaultQuoteAsset)
    }
    
    open var quoteAssets: [AssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
    open var request: ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
