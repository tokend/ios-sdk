import Foundation

public struct AccountIdentityResponse<SpecificAttributes: Decodable>: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    
    public let specificAttributes: SpecificAttributes
    
    enum CodingKeys: String, CodingKey {
        
        case attributes
        case id
        case type
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        attributes = try container.decode(Attributes.self, forKey: .attributes)
        id = try container.decodeString(key: .id)
        type = try container.decodeString(key: .type)
        
        specificAttributes = try container.decode(SpecificAttributes.self, forKey: .attributes)
    }
}

extension AccountIdentityResponse {
    
    public struct Attributes: Decodable {
        
        public let address: String
        public let email: String
        public let phoneNumber: String?
    }
}

public struct EmptySpecificAttributes: Decodable { }
