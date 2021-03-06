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
    
    public var type: TokenDSDK.BlobType? {
        return TokenDSDK.BlobType(rawValue: self.typeString)
    }
}

// MARK: - Private methods

private extension BlobResponse {

    func getValue<T>() throws -> T where T: Decodable {
        return try T.decode(from: try self.attributes.getJSONData())
    }
}

// MARK: - Attributes

extension BlobResponse {
    
    public struct Attributes: Decodable {
        
        public let value: String

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
}

// MARK: - BlobContent

extension BlobResponse {
    
    public enum BlobContent {
        case assetDescription(string: String)
        case fundDocument(document: FundDocumentResponse)
        case fundOverview(markdown: String)
        case fundUpdate(update: FundUpdateResponse)

        case kycData(data: Data)
        case tokenMetrics(metrics: FundDocumentResponse)
        case unknown
    }
    
    public func getBlobContent() -> BlobContent {
        switch self.type {
            
        case .assetDescription:
            return BlobContent.assetDescription(string: attributes.value)
            
        case .fundOverview:
            return BlobContent.fundOverview(markdown: attributes.value)
            
        case .fundUpdate:

            if let update: BlobContent.FundUpdateResponse = try? getValue() {
                return BlobContent.fundUpdate(update: update)
            } else if let document: BlobContent.FundDocumentResponse = try? getValue() {
                return BlobContent.fundDocument(document: document)
            }

            return .unknown
            
        case .kycForm:
            guard let data = try? self.attributes.getJSONData() else {
                return .unknown
            }

            return .kycData(data: data)
            
        case .tokenMetrics:

            if let metrics: BlobContent.FundDocumentResponse = try? getValue() {
                return BlobContent.tokenMetrics(metrics: metrics)
            }

            return .unknown
            
        default:
            return .unknown
        }
    }
}

// MARK: - FundUpdateResponse

extension BlobResponse.BlobContent {
    
    public struct FundUpdateResponse: Decodable {
        
        public let date: Date
        public let message: String
        public let title: String
        
        public enum FundUpdateResponseCodingKeys: String, CodingKey {
            case date
            case message
            case title
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: FundUpdateResponseCodingKeys.self)
            
            self.date = try container.decodeDateString(key: .date)
            self.message = try container.decodeString(key: .message)
            self.title = try container.decodeString(key: .title)
        }
    }
}

// MARK: - FundDocumentResponse

extension BlobResponse.BlobContent {
    
    public struct FundDocumentResponse: Decodable {
        
        public let name: String
        public let url: String?
        public let key: String?
        public let type: String?
    }
}

extension BlobResponse.BlobContent {

    public struct Attachment: Codable {

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

// MARK: - Debug Description

extension BlobResponse.BlobContent: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var description: String = "BlobResponse.BlobContent"
        
        switch self {
            
        case .assetDescription(let string):
            description.append(".assetDescription: \(string)")
            
        case .fundDocument(let document):
            description.append(".fundDocument: \(document)")
            
        case .fundOverview(let markdown):
            description.append(".fundOverview: \(markdown)")
            
        case .fundUpdate(let update):
            description.append(".fundUpdate: \(update)")

        case .kycData(let data):
            let form = String(data: data, encoding: String.Encoding.utf8) ?? ""
            description.append(".kycForm: \(form)")
            
        case .tokenMetrics(let metrics):
            description.append(".tokenMetrics: \(metrics)")
            
        case .unknown:
            description.append(".unknown")
        }
        
        return description
    }
}
