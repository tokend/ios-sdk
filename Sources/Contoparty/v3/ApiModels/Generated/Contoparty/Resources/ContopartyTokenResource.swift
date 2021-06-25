// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - TokenResource

extension Contoparty {
open class TokenResource: Resource {
    
    open override class var resourceType: String {
        return "tokens"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case assetCode
        case creator
        case details
        case editionId
        case ethId
        case numberInEdition
        case owner
        case status
        
        // relations
        case externalId
    }
    
    // MARK: Attributes
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var creator: String? {
        return self.stringOptionalValue(key: CodingKeys.creator)
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var editionId: Int64? {
        return self.int64OptionalValue(key: CodingKeys.editionId)
    }
    
    open var ethId: Int64? {
        return self.int64OptionalValue(key: CodingKeys.ethId)
    }
    
    open var numberInEdition: Int32? {
        return self.int32OptionalValue(key: CodingKeys.numberInEdition)
    }
    
    open var owner: String {
        return self.stringOptionalValue(key: CodingKeys.owner) ?? ""
    }
    
    open var status: Int32 {
        return self.int32OptionalValue(key: CodingKeys.status) ?? 0
    }
    
    // MARK: Relations
    
    open var externalId: Contoparty.ExternalIdResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.externalId)
    }
    
}
}
