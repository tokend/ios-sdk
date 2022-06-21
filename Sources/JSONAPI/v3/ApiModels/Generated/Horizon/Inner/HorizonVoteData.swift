// Auto-generated code. Do not edit.

import Foundation

// MARK: - VoteData

extension Horizon {
public struct VoteData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case creationTime
        case customChoice
        case pollType
        case singleChoice
    }
    
    // MARK: Attributes
    
    public let creationTime: Date?
    public let customChoice: String?
    public let pollType: Enum
    public let singleChoice: UInt64?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.creationTime = try? container.decodeOptionalDateString(key: .creationTime)
        self.customChoice = try? container.decode(String.self, forKey: .customChoice)
        self.pollType = try container.decode(Enum.self, forKey: .pollType)
        self.singleChoice = try? container.decode(UInt64.self, forKey: .singleChoice)
    }

}
}
