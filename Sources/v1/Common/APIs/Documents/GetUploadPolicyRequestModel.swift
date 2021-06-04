import Foundation

public struct GetUploadPolicyRequestModel: Encodable {
    
    public let type: String
    public let attributes: Attributes
    public let relationships: Relationships
}

public extension GetUploadPolicyRequestModel {
    
    struct Attributes: Encodable {
        
        let contentType: String
    }
}

public extension GetUploadPolicyRequestModel {
    
    struct Relationships: Encodable {
        
        public let owner: Owner
    }
}

public extension GetUploadPolicyRequestModel.Relationships {

    struct Owner: Encodable {

        public let data: Data
    }
}

public extension GetUploadPolicyRequestModel.Relationships.Owner {

    struct Data: Encodable {

        public let id: String
    }
}
