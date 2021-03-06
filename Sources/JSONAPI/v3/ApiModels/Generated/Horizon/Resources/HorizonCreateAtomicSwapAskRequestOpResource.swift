// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateAtomicSwapAskRequestOpResource

extension Horizon {
open class CreateAtomicSwapAskRequestOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-create-atomic-swap-ask-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case creatorDetails
        
        // relations
        case baseBalance
        case quoteAssets
        case request
    }
    
    // MARK: Attributes
    
    open var amount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.amount) ?? 0.0
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    // MARK: Relations
    
    open var baseBalance: Horizon.BalanceResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.baseBalance)
    }
    
    open var quoteAssets: [Horizon.AssetResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.quoteAssets)
    }
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
