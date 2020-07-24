// Auto-generated code. Do not edit.

import Foundation

// MARK: - CreateAccountSpecificRuleData

extension Horizon {
public struct CreateAccountSpecificRuleData: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        // attributes
        case accountId
        case forbids
        case ledgerKey
    }
    
    // MARK: Attributes
    
    public let accountId: String?
    public let forbids: Bool
    public let ledgerKey: [String: Any]

    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accountId = try? container.decode(String.self, forKey: .accountId)
        self.forbids = try container.decode(Bool.self, forKey: .forbids)
        self.ledgerKey = try container.decodeDictionary([String: Any].self, forKey: .ledgerKey)
    }

}
}
