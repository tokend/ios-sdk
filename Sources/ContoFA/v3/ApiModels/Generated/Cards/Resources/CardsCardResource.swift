// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CardResource

extension Cards {
open class CardResource: Resource {
    
    open override class var resourceType: String {
        return "cards"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case state
        
        // relations
        case balances
        case owner
        case securityDetails
    }
    
    // MARK: Attributes
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var state: Cards.Enum? {
        return self.codableOptionalValue(key: CodingKeys.state)
    }
    
    // MARK: Relations
    
    open var balances: [Cards.CardBalanceResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.balances)
    }
    
    open var owner: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
    open var securityDetails: Cards.CardSecurityDetailsResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.securityDetails)
    }
    
}
}
