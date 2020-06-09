// Auto-generated code. Do not edit.

import Foundation

// MARK: - CreatePollRequestOp

extension Horizon {
public struct CreatePollRequestOp: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case allTasks
        case creatorDetails
        case endTime
        case numberOfChoices
        case permissionType
        case pollData
        case resultProviderId
        case startTime
        case voteConfirmationRequired
    }
    
    // MARK: Attributes
    
    public let allTasks: UInt32?
    public let creatorDetails: [String: Any]
    public let endTime: Date
    public let numberOfChoices: UInt64
    public let permissionType: UInt64
    public let pollData: PollData
    public let resultProviderId: String
    public let startTime: Date
    public let voteConfirmationRequired: Bool

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.allTasks = try? container.decode(UInt32.self, forKey: .allTasks)
        self.creatorDetails = try container.decodeDictionary([String: Any].self, forKey: .creatorDetails)
        self.endTime = try container.decode(Date.self, forKey: .endTime)
        self.numberOfChoices = try container.decode(UInt64.self, forKey: .numberOfChoices)
        self.permissionType = try container.decode(UInt64.self, forKey: .permissionType)
        self.pollData = try container.decode(PollData.self, forKey: .pollData)
        self.resultProviderId = try container.decode(String.self, forKey: .resultProviderId)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.voteConfirmationRequired = try container.decode(Bool.self, forKey: .voteConfirmationRequired)
    }

}
}
