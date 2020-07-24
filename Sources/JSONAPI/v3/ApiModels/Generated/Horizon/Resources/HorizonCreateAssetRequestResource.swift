// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - CreateAssetRequestResource

extension Horizon {
open class CreateAssetRequestResource: BaseReviewableRequestDetailsResource {
    
    open override class var resourceType: String {
        return "request-details-asset-create"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case assetCode
        case creatorDetails
        case initialPreissuedAmount
        case maxIssuanceAmount
        case policies
        case preIssuanceAssetSigner
        case trailingDigitsCount
        case type
        
        // relations
        case asset
    }
    
    // MARK: Attributes
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
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
    
    open var trailingDigitsCount: UInt32 {
        return self.uint32OptionalValue(key: CodingKeys.trailingDigitsCount) ?? 0
    }
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
    // MARK: Relations
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
}
