// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - RemoveAssetOpResource

extension Horizon {
open class RemoveAssetOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-remove-asset"
    }
    
    public enum CodingKeys: String, CodingKey {
        // relations
        case asset
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
}
