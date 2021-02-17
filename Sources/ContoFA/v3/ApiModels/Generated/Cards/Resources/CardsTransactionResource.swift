// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TransactionResource

extension Cards {
open class TransactionResource: Resource {
    
    open override class var resourceType: String {
        return "transcations"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case env
        
        // relations
        case destinationCard
        case sourceCard
    }
    
    // MARK: Attributes
    
    open var env: String {
        return self.stringOptionalValue(key: CodingKeys.env) ?? ""
    }
    
    // MARK: Relations
    
    open var destinationCard: Cards.CardResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.destinationCard)
    }
    
    open var sourceCard: Cards.CardResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.sourceCard)
    }
    
}
}
