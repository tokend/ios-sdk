import Foundation

public struct CreateDraftRequest: Encodable {
    
    let data: Data
}

extension CreateDraftRequest {
    
    struct Data: Encodable {
        
        let type: String
        let attributes: Attributes
    }
}

extension CreateDraftRequest {
    
    public struct Attributes: Encodable {
        let assetCode: String
        let creator: String
        let details: Details
        let type: TokenType
    }
}

extension CreateDraftRequest.Attributes {
    
    struct TokenType: Encodable {
        let name: String
        let value: Int32
    }
}

extension CreateDraftRequest.Attributes {
    
    public struct Details: Encodable {
        let logo: String
        let name: String
        let image: String?
        let medium: String?
        let logoUrl: String?
        let isDraft: Bool
        let dimensions: String?
        let logoDraft: BlobResponse.BlobContent.Attachment
        let mediaSize: Int64?
        let description: String
        let mediaDraft: BlobResponse.BlobContent.Attachment
        let animationUrl: String?
        let collaborators: String?
        let dateOrSeason: String?
        let representation: String?
        let directionsForUse: String?
        let unlockableContent: String?
    }
}
