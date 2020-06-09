// Auto-generated code. Do not edit.

import Foundation

// MARK: - ClosePollOp

extension Horizon {
public struct ClosePollOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case details
        case pollId
        case pollResult
    }
    
    // MARK: Attributes
    
    public let details: [String: Any]
    public let pollId: Int64
    public let pollResult: Enum

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.details = try container.decodeDictionary([String: Any].self, forKey: .details)
        self.pollId = try container.decode(Int64.self, forKey: .pollId)
        self.pollResult = try container.decode(Enum.self, forKey: .pollResult)
    }

}
}
