// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TokenHistoryResource

extension Contoparty {
open class TokenHistoryResource: Resource {
    
    open override class var resourceType: String {
        return "token-histories"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case assetCode
        case createdAt
        case details
        case opType
        case receiverId
        case senderId
        case tokenId
        
        // relations
        case externalId
    }
    
    // MARK: Attributes
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var createdAt: Date {
        return self.dateOptionalValue(key: CodingKeys.createdAt) ?? Date()
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var opType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.opType) ?? 0
    }
    
    open var receiverId: String {
        return self.stringOptionalValue(key: CodingKeys.receiverId) ?? ""
    }
    
    open var senderId: String {
        return self.stringOptionalValue(key: CodingKeys.senderId) ?? ""
    }
    
    open var tokenId: Int32 {
        return self.int32OptionalValue(key: CodingKeys.tokenId) ?? 0
    }
    
    // MARK: Relations
    
    open var externalId: Contoparty.ExternalIdResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.externalId)
    }
    
}
}
