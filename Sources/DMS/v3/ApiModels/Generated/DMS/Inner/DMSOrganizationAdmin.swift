// Auto-generated code. Do not edit.

import Foundation

// MARK: - OrganizationAdmin

extension DMS {
public struct OrganizationAdmin: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case email
        case name
        case phone
    }
    
    // MARK: Attributes
    
    public let email: String
    public let name: String
    public let phone: String

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decode(String.self, forKey: .name)
        self.phone = try container.decode(String.self, forKey: .phone)
    }

}
}
