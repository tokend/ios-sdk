// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - LimitsWithStatsResource

extension Horizon {
open class LimitsWithStatsResource: Resource {
    
    open override class var resourceType: String {
        return "limits-with-stats"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case limits
        case statistics
        
        // relations
        case account
    }
    
    // MARK: Attributes
    
    open var limits: Horizon.LimitsResource? {
        return self.value(forKey: CodingKeys.limits) as? Horizon.LimitsResource
    }
    
    open var statistics: Horizon.StatisticsResource? {
        return self.value(forKey: CodingKeys.statistics) as? Horizon.StatisticsResource
    }
    
    // MARK: Relations
    
    open var account: Horizon.AccountResource? {
        return self.relationSingleOptionalValue(key: CodingKeys.account)
    }
    
}
}
