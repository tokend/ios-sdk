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
        case ethId
        case numberInEdition
        case owner
        case status
        case tokenType
        case type
        
        // relations
        case edition
        case externalId
        case withdrawRequest
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
    
    open var tokenType: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.tokenType)
    }
    
    open var attributesType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    // MARK: Relations
    
    open var edition: Contoparty.EditionResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.edition)
    }
    
    open var externalId: [Contoparty.ExternalIdResource]? {
        return self.relationCollectionOptionalValue(key: CodingKeys.externalId)
    }
    
    open var withdrawRequest: Resource? {
        return self.relationSingleOptionalValue(key: CodingKeys.withdrawRequest)
    }
    
}
}
