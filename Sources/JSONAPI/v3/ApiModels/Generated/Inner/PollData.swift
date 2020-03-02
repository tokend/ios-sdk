// Auto-generated code. Do not edit.

import Foundation

// MARK: - PollData

public struct PollData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case type
    }
    
    // MARK: Attributes
    
    public let type: XdrEnumValue

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(XdrEnumValue.self, forKey: .type)
    }

}
