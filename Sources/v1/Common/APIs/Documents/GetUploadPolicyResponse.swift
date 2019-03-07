import Foundation

public struct GetUploadPolicyResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        
        case type
        case attributes
        case url = "attributes.url"
    }
    
    // MARK: - Public properties
    
    public let type: String
    public let attributes: JSON
    public let url: String
    
    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(String.self, forKey: .type)
        var attributesDict = try container.decodeDictionary(JSON.self, forKey: .attributes)
        
        guard let url = attributesDict["url"] as? String else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.url,
                in: container,
                debugDescription: "Upload policy response attributes contain no url."
            )
        }
        
        attributesDict.removeValue(forKey: "url")
        
        self.attributes = attributesDict
        self.url = url
    }
}
