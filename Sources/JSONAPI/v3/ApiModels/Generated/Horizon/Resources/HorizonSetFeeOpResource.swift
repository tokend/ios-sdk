// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - SetFeeOpResource

extension Horizon {
open class SetFeeOpResource: BaseOperationDetailsResource {
    
    open override class var resourceType: String {
        return "operations-set-fees"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountAddress
        case accountRole
        case assetCode
        case feeType
        case fixedFee
        case isDelete
        case lowerBound
        case percentFee
        case subtype
        case upperBound
    }
    
    // MARK: Attributes
    
    open var accountAddress: String? {
        return self.stringOptionalValue(key: CodingKeys.accountAddress)
    }
    
    open var accountRole: UInt64? {
        return self.uint64OptionalValue(key: CodingKeys.accountRole)
    }
    
    open var assetCode: String {
        return self.stringOptionalValue(key: CodingKeys.assetCode) ?? ""
    }
    
    open var feeType: Horizon.Enum? {
        return self.codableOptionalValue(key: CodingKeys.feeType)
    }
    
    open var fixedFee: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.fixedFee) ?? 0.0
    }
    
    open var isDelete: Bool {
        return self.boolOptionalValue(key: CodingKeys.isDelete) ?? false
    }
    
    open var lowerBound: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.lowerBound) ?? 0.0
    }
    
    open var percentFee: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.percentFee) ?? 0.0
    }
    
    open var subtype: Int64 {
        return self.int64OptionalValue(key: CodingKeys.subtype) ?? 0
    }
    
    open var upperBound: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.upperBound) ?? 0.0
    }
    
}
}
