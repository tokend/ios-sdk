// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageAssetPairOpResource

extension Horizon {
open class ManageAssetPairOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-asset-pair"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case maxPriceStep
        case physicalPrice
        case physicalPriceCorrection
        case policies
        
        // relations
        case baseAsset
        case quoteAsset
    }
    
    // MARK: Attributes
    
    open var maxPriceStep: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxPriceStep) ?? 0.0
    }
    
    open var physicalPrice: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.physicalPrice) ?? 0.0
    }
    
    open var physicalPriceCorrection: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.physicalPriceCorrection) ?? 0.0
    }
    
    open var policies: Horizon.Mask? {
        return self.codableOptionalValue(key: CodingKeys.policies)
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
