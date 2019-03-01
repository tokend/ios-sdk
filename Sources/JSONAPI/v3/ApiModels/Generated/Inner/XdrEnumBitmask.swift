// Auto-generated code. Do not edit.

import Foundation

// MARK: - XdrEnumBitmask

public struct XdrEnumBitmask: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case flags
        case value
    }
    
    // MARK: Attributes
    
    public let flags: [XdrEnumValue]
    public let value: Int32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.flags = try container.decode([XdrEnumValue].self, forKey: .flags)
        self.value = try container.decode(Int32.self, forKey: .value)
    }

}
