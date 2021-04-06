// Auto-generated code. Do not edit.

import Foundation

// MARK: - StepUser

extension DMS {
public struct StepUser: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case id
    }
    
    // MARK: Attributes
    
    public let id: String?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decode(String.self, forKey: .id)
    }

}
}
