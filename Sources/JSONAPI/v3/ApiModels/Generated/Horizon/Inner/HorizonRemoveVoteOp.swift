// Auto-generated code. Do not edit.

import Foundation

// MARK: - RemoveVoteOp

extension Horizon {
public struct RemoveVoteOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case pollId
    }
    
    // MARK: Attributes
    
    public let pollId: Int64

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.pollId = try container.decode(Int64.self, forKey: .pollId)
    }

}
}
