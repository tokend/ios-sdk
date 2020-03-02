// Auto-generated code. Do not edit.

import Foundation

// MARK: - VoteData

public struct VoteData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case pollType
        case singleChoice
    }
    
    // MARK: Attributes
    
    public let pollType: XdrEnumValue
    public let singleChoice: UInt64?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.pollType = try container.decode(XdrEnumValue.self, forKey: .pollType)
        self.singleChoice = try? container.decode(UInt64.self, forKey: .singleChoice)
    }

}
