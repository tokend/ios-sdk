import Foundation

public struct GetUploadPolicyResponse: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        
        case type
        case attributes
        case url = "attributes.url"
        case key = "attributes.key"
    }
    
    // MARK: - Public properties
    
    public let type: String
    public let attributes: JSON
    public let url: String
    public let documentId: String
    
    // MARK: -
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.type = try container.decode(String.self, forKey: .type)
        var attributesDict = try container.decodeDictionary(JSON.self, forKey: .attributes)
        
        guard let url = attributesDict["url"] as? String,
            let key = attributesDict["key"] as? String else {
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.url,
                in: container,
                debugDescription: "Upload policy response attributes contain no url and/or key."
            )
        }
        
        attributesDict.removeValue(forKey: "url")
        
        self.attributes = attributesDict
        self.url = url
        self.documentId = key
    }
}
