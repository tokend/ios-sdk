// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - ManageAssetOpResource

extension Horizon {
open class ManageAssetOpResource: BaseOperationDetailsResource {
    
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
        case preIssuanceSigner
        
        // relations
        case request
    }
    
    // MARK: Attributes
    
    open var action: Horizon.Enum? {
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
    
    open var policies: Horizon.Mask? {
        return self.codableOptionalValue(key: CodingKeys.policies)
    }
    
    open var preIssuanceSigner: String {
        return self.stringOptionalValue(key: CodingKeys.preIssuanceSigner) ?? ""
    }
    
    // MARK: Relations
    
    open var request: Horizon.ReviewableRequestResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.request)
    }
    
}
}
