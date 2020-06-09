// Auto-generated code. Do not edit.

import Foundation

// MARK: - CreateVoteOp

extension Horizon {
public struct CreateVoteOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case pollId
        case voteData
    }
    
    // MARK: Attributes
    
    public let pollId: Int64
    public let voteData: VoteData

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.pollId = try container.decode(Int64.self, forKey: .pollId)
        self.voteData = try container.decode(VoteData.self, forKey: .voteData)
    }

}
}
