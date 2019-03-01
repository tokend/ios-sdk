// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - OpManageAssetDetailsResource

open class OpManageAssetDetailsResource: OperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-manage-asset"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case action
        case assetCode
        case creatorDetails
        case maxIssuanceAmount
        case policies
        case preissuanceSigner
        case type
    }
    
    // MARK: Attributes
    
    open var action: XdrEnumValue? {
        return self.codableOptionalValue(key: CodingKeys.action)
    }
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var creatorDetails: [String: Any] {
        return self.dictionaryOptionalValue(key: CodingKeys.creatorDetails) ?? [:]
    }
    
    open var maxIssuanceAmount: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.maxIssuanceAmount) ?? 0.0
    }
    
    open var policies: XdrEnumBitmask? {
        return self.codableOptionalValue(key: CodingKeys.policies)
    }
    
    open var preissuanceSigner: String {
        return self.stringOptionalValue(key: CodingKeys.preissuanceSigner) ?? ""
    }
    
    open var attributesType: UInt64 {
        return self.uint64OptionalValue(key: CodingKeys.type) ?? 0
    }
    
}
