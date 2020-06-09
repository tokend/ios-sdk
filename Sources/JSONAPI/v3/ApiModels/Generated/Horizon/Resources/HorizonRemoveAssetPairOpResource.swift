// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RemoveAssetPairOpResource

extension Horizon {
open class RemoveAssetPairOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-remove-asset-pair"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case base
        case quote
    }
    
    // MARK: Relations
    
    open var base: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.base)
    }
    
    open var quote: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.quote)
    }
    
}
}
