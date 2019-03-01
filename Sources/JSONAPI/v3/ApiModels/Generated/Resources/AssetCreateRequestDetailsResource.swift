// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - AssetCreateRequestDetailsResource

open class AssetCreateRequestDetailsResource: RequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-asset-create"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case asset
        case creatorDetails
        case initialPreissuedAmount
        case maxIssuanceAmount
        case policies
        case preIssuanceAssetSigner
        case type
    }
    
    // MARK: Attributes
    
    open var asset: String {
        return self.stringOptionalValue(key: CodingKeys.asset) ?? ""
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var initialPreissuedAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.initialPreissuedAmount) ?? 0.0
    }
    
    open var maxIssuanceAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxIssuanceAmount) ?? 0.0
    }
    
    open var policies: Int32 {
        return self.int32OptionalValue(key: CodingKeys.policies) ?? 0
    }
    
    open var preIssuanceAssetSigner: String {
        return self.stringOptionalValue(key: CodingKeys.preIssuanceAssetSigner) ?? ""
    }
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
}
