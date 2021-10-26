// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - EditionResource

extension Contoparty {
open class EditionResource: Resource {
    
    open override class var resourceType: String {
        return "editions"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case createdAt
        case creator
        case minted
        case name
        
        // relations
        case tokens
    }
    
    // MARK: Attributes
    
    open var amount: Int64 {
        return self.int64OptionalValue(key: CodingKeys.amount) ?? 0
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var creator: String? {
        return self.stringOptionalValue(key: CodingKeys.creator)
    }
    
    open var minted: Int64 {
        return self.int64OptionalValue(key: CodingKeys.minted) ?? 0
    }
    
    open var name: String {
        return self.stringOptionalValue(key: CodingKeys.name) ?? ""
    }
    
    // MARK: Relations
    
    open var tokens: [Contoparty.TokenResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.tokens)
    }
    
}
}
