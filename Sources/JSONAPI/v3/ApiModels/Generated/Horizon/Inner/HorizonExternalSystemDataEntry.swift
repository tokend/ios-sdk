// Auto-generated code. Do not edit.

import Foundation

// MARK: - ExternalSystemDataEntry

extension Horizon {
public struct ExternalSystemDataEntry: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case address
        case payload
    }
    
    // MARK: Attributes
    
    public let address: String
    public let payload: String?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.address = try container.decode(String.self, forKey: .address)
        self.payload = try? container.decode(String.self, forKey: .payload)
    }

}
}
