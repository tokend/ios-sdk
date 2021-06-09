// Auto-generated code. Do not edit.

import Foundation

// MARK: - LedgerInfo

extension Horizon {
public struct LedgerInfo: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case lastLedgerIncreaseTime
        case latest
        case oldestOnStart
    }
    
    // MARK: Attributes
    
    public let lastLedgerIncreaseTime: Date
    public let latest: UInt64
    public let oldestOnStart: UInt64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.lastLedgerIncreaseTime = try container.decodeDateString(key: .lastLedgerIncreaseTime)
        self.latest = try container.decode(UInt64.self, forKey: .latest)
        self.oldestOnStart = try container.decode(UInt64.self, forKey: .oldestOnStart)
    }

}
}
