import Foundation

// MARK: - BlobResponse

public struct BlobResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let typeString: String
    
    enum CodingKeys: String, CodingKey {
        
        case attributes
        case id
        case typeString = "type"
    }
}

// MARK: Public methods

public extension BlobResponse {
    
    var type: TokenDSDK.BlobType? {
        return TokenDSDK.BlobType(rawValue: self.typeString)
    }

    func getValue<T>() throws -> T where T: Decodable {
        return try T.decode(from: try getValue())
    }
    
    func getValue() throws -> Data {
        return try self.attributes.getJSONData()
    }
}

// MARK: - Attributes

public extension BlobResponse {
    
    struct Attributes: Decodable {
        
        public let value: String
    }
}

// MARK: Public methods

public extension BlobResponse.Attributes {
    
    enum GetJSONDataError: Error {
        case cannotGetJSON
    }
    func getJSONData() throws -> Data {
        guard let data = self.value.data(using: String.Encoding.utf8) else {
            throw GetJSONDataError.cannotGetJSON
        }
        
        return data
    }
}

// MARK: - Attachment

public extension BlobResponse {
    
    struct Attachment: Codable {

        public let mimeType: String
        public let name: String
        public let key: String

        public init(
            mimeType: String,
            name: String,
            key: String
        ) {

            self.mimeType = mimeType
            self.name = name
            self.key = key
        }
    }
}
