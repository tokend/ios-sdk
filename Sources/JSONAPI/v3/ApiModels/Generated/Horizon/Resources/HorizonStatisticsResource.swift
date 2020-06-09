// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - StatisticsResource

extension Horizon {
open class StatisticsResource: Resource {
    
    open override class var resourceType: String {
        return "statistics"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case annualOut
        case dailyOut
        case isConvertNeeded
        case monthlyOut
        case operationType
        case updatedAt
        case weeklyOut
        
        // relations
        case account
        case asset
    }
    
    // MARK: Attributes
    
    open var annualOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.annualOut) ?? 0.0
    }
    
    open var dailyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.dailyOut) ?? 0.0
    }
    
    open var isConvertNeeded: Bool {
        return self.boolOptionalValue(key: CodingKeys.isConvertNeeded) ?? false
    }
    
    open var monthlyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.monthlyOut) ?? 0.0
    }
    
    open var operationType: Int32 {
        return self.int32OptionalValue(key: CodingKeys.operationType) ?? 0
    }
    
    open var updatedAt: Date {
        return self.dateOptionalValue(key: CodingKeys.updatedAt) ?? Date()
    }
    
    open var weeklyOut: Decimal {
        return self.decimalOptionalValue(key: CodingKeys.weeklyOut) ?? 0.0
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
    open var asset: Horizon.AssetResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.asset)
    }
    
}
}
