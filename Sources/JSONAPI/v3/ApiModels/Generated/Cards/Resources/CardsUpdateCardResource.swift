// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - UpdateCardResource

extension Cards {
open class UpdateCardResource: Resource {
    
    open override class var resourceType: String {
        return "update-card-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case state
        
        // relations
        case bindBalances
        case unbindBalances
    }
    
    // MARK: Attributes
    
    open var state: Cards.Enum? {
        return self.codableOptionalValue(key: CodingKeys.state)
    }
    
    // MARK: Relations
    
    open var bindBalances: [Resource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.bindBalances)
    }
    
    open var unbindBalances: [Resource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.unbindBalances)
    }
    
}
}
