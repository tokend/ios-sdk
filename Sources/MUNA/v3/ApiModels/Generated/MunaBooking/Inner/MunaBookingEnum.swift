// Auto-generated code. Do not edit.

import Foundation

// MARK: - Enum

extension MunaBooking {
public struct Enum: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case name
        case value
    }
    
    // MARK: Attributes
    
    public let name: String
    public let value: Int32

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(Int32.self, forKey: .value)
    }

}
}
