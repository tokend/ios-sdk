// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateCardResource

extension Cards {
open class CreateCardResource: Resource {
    
    open override class var resourceType: String {
        return "add-card-request"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case cardNumber
        case details
        
        // relations
        case balances
        case owner
        case securityDetails
    }
    
    // MARK: Attributes
    
    open var cardNumber: String {
        return self.stringOptionalValue(key: CodingKeys.cardNumber) ?? ""
    }
    
    open var details: [String: Any]? {
        return self.dictionaryOptionalValue(key: CodingKeys.details)
    }
    
    // MARK: Relations
    
    open var balances: [Resource]? {
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
