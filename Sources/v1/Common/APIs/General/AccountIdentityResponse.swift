import Foundation

public struct AccountIdentityResponse: Decodable {
    
    public let attributes: Attributes
    public let id: String
    public let type: String
}

extension AccountIdentityResponse {
    
    public struct Attributes: Decodable {
        
        public let address: String
        public let email: String
        public let phoneNumber: String?
    }
}
