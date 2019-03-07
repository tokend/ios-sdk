import Foundation

public struct GetUploadPolicyRequest: Encodable {
    
    // MARK: - Public properties
    
    public let type: String
    public let attributes: Attributes
    
    // MARK: -
    
    public init(policyType: String, contentType: String) {
        self.type = policyType
        self.attributes = Attributes(contentType: contentType)
    }
}

extension GetUploadPolicyRequest {
    
    public struct Attributes: Encodable {
        
        public let contentType: String
        
        public init(contentType: String) {
            self.contentType = contentType
        }
    }
}
