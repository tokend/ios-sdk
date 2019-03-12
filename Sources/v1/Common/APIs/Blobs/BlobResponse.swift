import Foundation

// MARK: - BlobResponse

public struct BlobResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
    
    public var blobType: BlobType {
        return BlobType(rawValue: self.type) ?? .unknown
    }
    
    public enum BlobType: String, Decodable {
        case assetDescription   = "asset_description"
        case fundOverview       = "fund_overview"
        case fundUpdate         = "fund_update"
        case kycForm            = "kyc_form"
        case tokenMetrics       = "token_metrics"
        case unknown
    }
}

// MARK: - Attributes

extension BlobResponse {
    
    public struct Attributes: Decodable {
        
        public let value: String
    }
}

// MARK: - BlobContent

extension BlobResponse {
    
    public enum BlobContent {
        case assetDescription(string: String)
        case fundDocument(document: FundDocumentResponse)
        case fundOverview(markdown: String)
        case fundUpdate(update: FundUpdateResponse)
        case kycForm(form: KYCFormResponse)
        case tokenMetrics(metrics: FundDocumentResponse)
        case unknown
    }
    
    public func getBlobContent() -> BlobContent {
        switch self.blobType {
            
        case .assetDescription:
            return BlobContent.assetDescription(string: attributes.value)
            
        case .fundOverview:
            return BlobContent.fundOverview(markdown: attributes.value)
            
        case .fundUpdate:
            guard let data = self.attributes.value.data(using: String.Encoding.utf8) else {
                return .unknown
            }
            
            if let update = try? BlobContent.FundUpdateResponse.decode(from: data) {
                return BlobContent.fundUpdate(update: update)
            } else if let document = try? BlobContent.FundDocumentResponse.decode(from: data) {
                return BlobContent.fundDocument(document: document)
            } else {
                return .unknown
            }
            
        case .kycForm:
            guard let data = self.attributes.value.data(using: String.Encoding.utf8) else {
                return .unknown
            }
            
            if let form = try? BlobContent.KYCFormResponse.decode(from: data) {
                return BlobContent.kycForm(form: form)
            } else {
                return .unknown
            }
            
        case .tokenMetrics:
            guard let data = attributes.value.data(using: String.Encoding.utf8) else {
                return .unknown
            }
            
            if let metrics = try? BlobContent.FundDocumentResponse.decode(from: data) {
                return BlobContent.tokenMetrics(metrics: metrics)
            } else {
                return .unknown
            }
            
        case .unknown:
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

// MARK: - KYCFormResponse

extension BlobResponse.BlobContent {
    
    public struct KYCFormResponse: Decodable {
        
        public struct Documents: Decodable {
            
            public struct Attachment: Decodable {
                
                public let mimeType: String?
                public let name: String?
                public let key: String?
            }
            
            public let kycIdDocument: Attachment?
            public let kycSelfie: Attachment?
        }
        
        public let firstName: String?
        public let lastName: String?
        public let documents: Documents?
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
            
        case .kycForm(let form):
            description.append(".kycForm: \(form)")
            
        case .tokenMetrics(let metrics):
            description.append(".tokenMetrics: \(metrics)")
            
        case .unknown:
            description.append(".unknown")
        }
        
        return description
    }
}
