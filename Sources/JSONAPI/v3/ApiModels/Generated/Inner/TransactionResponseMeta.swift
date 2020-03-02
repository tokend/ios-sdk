// Auto-generated code. Do not edit.

import Foundation

// MARK: - TransactionResponseMeta

public struct TransactionResponseMeta: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case latestLedgerCloseTime
        case latestLedgerSequence
    }
    
    // MARK: Attributes
    
    public let latestLedgerCloseTime: Date
    public let latestLedgerSequence: Int32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.latestLedgerCloseTime = try container.decode(Date.self, forKey: .latestLedgerCloseTime)
        self.latestLedgerSequence = try container.decode(Int32.self, forKey: .latestLedgerSequence)
    }

}
