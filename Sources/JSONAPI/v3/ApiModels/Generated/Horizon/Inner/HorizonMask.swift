// Auto-generated code. Do not edit.

import Foundation

// MARK: - Mask

extension Horizon {
public struct Mask: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case flags
        case value
    }
    
    // MARK: Attributes
    
    public let flags: [Enum]?
    public let value: Int32?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.flags = try? container.decode([Enum].self, forKey: .flags)
        self.value = try? container.decode(Int32.self, forKey: .value)
    }

}
}
