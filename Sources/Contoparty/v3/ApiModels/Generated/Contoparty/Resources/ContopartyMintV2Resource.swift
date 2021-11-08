// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - MintV2Resource

extension Contoparty {
open class MintV2Resource: Resource {
    
    open override class var resourceType: String {
        return "mint-tokens"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case amount
        case assetCode
        case details
        case ipfsUrl
        case mintTarget
        case senderAccountId
        case tokenType
        
        // relations
        case edition
    }
    
    // MARK: Attributes
    
    open var amount: Int64? {
        return self.int64OptionalValue(key: CodingKeys.amount)
    }
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var ipfsUrl: String {
        return self.stringOptionalValue(key: CodingKeys.ipfsUrl) ?? ""
    }
    
    open var mintTarget: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.mintTarget)
    }
    
    open var senderAccountId: String {
        return self.stringOptionalValue(key: CodingKeys.senderAccountId) ?? ""
    }
    
    open var tokenType: Contoparty.Enum? {
        return self.codableOptionalValue(key: CodingKeys.tokenType)
    }
    
    // MARK: Relations
    
    open var edition: Contoparty.CreateEditionResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.edition)
    }
    
}
}
