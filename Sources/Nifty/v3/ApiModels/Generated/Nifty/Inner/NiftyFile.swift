// Auto-generated code. Do not edit.

import Foundation

// MARK: - File

extension Nifty {
public struct File: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case key
        case mimeType
        case name
    }
    
    // MARK: Attributes
    
    public let key: String
    public let mimeType: String
    public let name: String

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.key = try container.decode(String.self, forKey: .key)
        self.mimeType = try container.decode(String.self, forKey: .mimeType)
        self.name = try container.decode(String.self, forKey: .name)
    }

}
}
