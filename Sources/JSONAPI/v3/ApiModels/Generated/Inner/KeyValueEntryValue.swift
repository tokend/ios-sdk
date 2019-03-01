// Auto-generated code. Do not edit.

import Foundation

// MARK: - KeyValueEntryValue

public struct KeyValueEntryValue: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case str
        case type
        case u32
        case u64
    }
    
    // MARK: Attributes
    
    public let str: String?
    public let type: XdrEnumValue
    public let u32: UInt32?
    public let u64: UInt64?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.str = try? container.decode(String.self, forKey: .str)
        self.type = try container.decode(XdrEnumValue.self, forKey: .type)
        self.u32 = try? container.decode(UInt32.self, forKey: .u32)
        self.u64 = try? container.decode(UInt64.self, forKey: .u64)
    }

}
