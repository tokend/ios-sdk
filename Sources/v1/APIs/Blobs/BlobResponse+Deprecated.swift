import Foundation

// MARK: - BlobContent

@available(*, deprecated)
extension BlobResponse {
    
    @available(*, deprecated)
    public enum BlobContent {
        case assetDescription(string: String)
        case fundDocument(document: FundDocumentResponse)
        case fundOverview(markdown: String)
        case fundUpdate(update: FundUpdateResponse)

        case kycData(data: Data)
        case tokenMetrics(metrics: FundDocumentResponse)
        case unknown
    }
    
    @available(*, deprecated)
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

@available(*, deprecated)
extension BlobResponse.BlobContent {
    
    @available(*, deprecated)
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

@available(*, deprecated)
extension BlobResponse.BlobContent {
    
    @available(*, deprecated)
    public struct FundDocumentResponse: Decodable {
        
        public let name: String
        public let url: String?
        public let key: String?
        public let type: String?
    }
}

@available(*, deprecated)
extension BlobResponse.BlobContent {

    @available(*, deprecated, message: "Use BlobResponse.Attachment instead")
    public typealias Attachment = BlobResponse.Attachment
}

// MARK: - Debug Description

@available(*, deprecated)
extension BlobResponse.BlobContent: CustomDebugStringConvertible {
    
    @available(*, deprecated)
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
