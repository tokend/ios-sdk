// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AssetResource

open class AssetResource: Resource {
    
    open override class var resourceType: String {
        return "assets"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case availableForIssuance
        case details
        case issued
        case maxIssuanceAmount
        case pendingIssuance
        case policies
        case preIssuanceAssetSigner
        case trailingDigits
        case type
        
        // relations
        case owner
    }
    
    // MARK: Attributes
    
    open var availableForIssuance: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.availableForIssuance) ?? 0.0
    }
    
    open var details: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.details) ?? [:]
    }
    
    open var issued: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.issued) ?? 0.0
    }
    
    open var maxIssuanceAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxIssuanceAmount) ?? 0.0
    }
    
    open var pendingIssuance: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.pendingIssuance) ?? 0.0
    }
    
    open var policies: XdrEnumBitmask? {
        return self.codableOptionalValue(key: CodingKeys.policies)
    }
    
    open var preIssuanceAssetSigner: String {
        return self.stringOptionalValue(key: CodingKeys.preIssuanceAssetSigner) ?? ""
    }
    
    open var trailingDigits: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.trailingDigits) ?? 0
    }
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    // MARK: Relations
    
    open var owner: AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.owner)
    }
    
}
