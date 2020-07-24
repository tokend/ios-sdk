// Auto-generated code. Do not edit.

import Foundation
import DLJSONAPI

// MARK: - HorizonStateResource

extension Horizon {
open class HorizonStateResource: Resource {
    
    open override class var resourceType: String {
        return "horizon-state"
    }
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case core
        case coreVersion
        case currentTime
        case currentTimeUnix
        case environmentName
        case history
        case historyV2
        case masterAccountId
        case networkPassphrase
        case precision
        case txExpirationPeriod
        case xdrRevision
    }
    
    // MARK: Attributes
    
    open var core: Horizon.LedgerInfo? {
        return self.codableOptionalValue(key: CodingKeys.core)
    }
    
    open var coreVersion: String {
        return self.stringOptionalValue(key: CodingKeys.coreVersion) ?? ""
    }
    
    open var currentTime: Date {
        return self.dateOptionalValue(key: CodingKeys.currentTime) ?? Date()
    }
    
    open var currentTimeUnix: Int64 {
        return self.int64OptionalValue(key: CodingKeys.currentTimeUnix) ?? 0
    }
    
    open var environmentName: String {
        return self.stringOptionalValue(key: CodingKeys.environmentName) ?? ""
    }
    
    open var history: Horizon.LedgerInfo? {
        return self.codableOptionalValue(key: CodingKeys.history)
    }
    
    open var historyV2: Horizon.LedgerInfo? {
        return self.codableOptionalValue(key: CodingKeys.historyV2)
    }
    
    open var masterAccountId: String {
        return self.stringOptionalValue(key: CodingKeys.masterAccountId) ?? ""
    }
    
    open var networkPassphrase: String {
        return self.stringOptionalValue(key: CodingKeys.networkPassphrase) ?? ""
    }
    
    open var precision: Int64 {
        return self.int64OptionalValue(key: CodingKeys.precision) ?? 0
    }
    
    open var txExpirationPeriod: Int64 {
        return self.int64OptionalValue(key: CodingKeys.txExpirationPeriod) ?? 0
    }
    
    open var xdrRevision: String {
        return self.stringOptionalValue(key: CodingKeys.xdrRevision) ?? ""
    }
    
}
}
