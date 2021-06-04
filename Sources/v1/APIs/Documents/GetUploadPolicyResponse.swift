import Foundation

public struct GetUploadPolicyResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        
        case type
        case attributes
    }
    
    // MARK: - Public properties
    
    public let type: String
    public let attributesJSON: JSON
    public let attributes: Attributes
    
    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(String.self, forKey: .type)
        self.attributes = try container.decode(Attributes.self, forKey: .attributes)
        
        var attributesDict = try container.decodeDictionary(JSON.self, forKey: .attributes)
        attributesDict.removeValue(forKey: "url")
        
        self.attributesJSON = attributesDict
    }
}

public extension GetUploadPolicyResponse {
    
    struct Attributes: Decodable {
        
        public let url: String
        public let key: String
    }
}
