// Auto-generated code. Do not edit.

import Foundation

// MARK: - PollData

extension Horizon {
public struct PollData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case type
    }
    
    // MARK: Attributes
    
    public let type: Enum

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(Enum.self, forKey: .type)
    }

}
}
