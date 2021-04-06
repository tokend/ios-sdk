// Auto-generated code. Do not edit.

import Foundation

// MARK: - Step

extension DMS {
public struct Step: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case comments
        case dateComplated
        case documentVersion
        case name
        case outcome
        case status
        case users
    }
    
    // MARK: Attributes
    
    public let comments: String?
    public let dateComplated: Date?
    public let documentVersion: Int32?
    public let name: String?
    public let outcome: Int32?
    public let status: Int32?
    public let users: [StepUser]?

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.comments = try? container.decode(String.self, forKey: .comments)
        self.dateComplated = try? container.decode(Date.self, forKey: .dateComplated)
        self.documentVersion = try? container.decode(Int32.self, forKey: .documentVersion)
        self.name = try? container.decode(String.self, forKey: .name)
        self.outcome = try? container.decode(Int32.self, forKey: .outcome)
        self.status = try? container.decode(Int32.self, forKey: .status)
        self.users = try? container.decode([StepUser].self, forKey: .users)
    }

}
}
